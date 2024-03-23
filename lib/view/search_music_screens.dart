import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';
import 'package:spotify_clone/view/widget/music_player.dart';

class SearchMusicScreens extends StatefulWidget {
  static const String id = 'search_music_screens';
  const SearchMusicScreens({super.key});

  @override
  State<SearchMusicScreens> createState() => _SearchMusicScreensState();
}

class _SearchMusicScreensState extends State<SearchMusicScreens> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel(); // Cancel any existing timer
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        var searchProvider =
            Provider.of<SearchProvider>(context, listen: false);
        searchProvider.searchSong(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              cursorColor: Colors.white,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
              controller: searchController,
              onChanged: (value) {
                _onSearchChanged(value);
              },
              decoration: InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                fillColor: Colors.grey.withOpacity(0.2),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: 'Search for songs, artists, albums',
                hintStyle: const TextStyle(color: Colors.white),
              ),
            )),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .clearSearchResults();
                Navigator.pop(context);
              },
              child: Text('Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white)),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  if (searchProvider.searchResults.isEmpty) {
                    return const Center(child: Text('No results found.'));
                  }

                  return ListView.builder(
                    itemCount: searchProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      var searchResult = searchProvider.searchResults[index];
                      return ListTile(
                        onTap: () {
                          Provider.of<MusicPlayerProvider>(context,
                                  listen: false)
                              .play(searchResult);
                        },
                        title: Text(searchResult.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                )),
                        subtitle: Text(searchResult.artists?[0].name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.6),
                                )),
                        leading: Image.network(
                            searchResult.album!.images?[0].url ?? ''),
                      );
                    },
                  );
                },
              ),
            ),
            const MusicPlayer()
          ]),
        ),
      ),
    );
  }
}
