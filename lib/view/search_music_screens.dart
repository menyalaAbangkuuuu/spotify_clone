import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/view/widget/slider_item_music.dart';

class SearchMusicScreens extends StatefulWidget {
  static const String id = '/search_music';

  const SearchMusicScreens({super.key});

  @override
  State<SearchMusicScreens> createState() => _SearchMusicScreensState();
}

class _SearchMusicScreensState extends State<SearchMusicScreens> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool _isEmpty = true;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (query.isNotEmpty) {
          var searchProvider =
              Provider.of<SearchProvider>(context, listen: false);
          searchProvider.searchSong(query);
          setState(() {
            _isEmpty = false;
          });
        } else {
          setState(() {
            _isEmpty = true;
          });
        }
      },
    );
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
                GoRouter.of(context).pop();
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
                    itemCount: searchProvider.searchResults.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= searchProvider.searchResults.length) {
                        return searchProvider.searchResults.length < 20
                            ? FractionallySizedBox(
                                widthFactor: 0.5,
                                child: ElevatedButton(
                                  onPressed: () {
                                    searchProvider.fetchMore(
                                        searchController.text,
                                        searchProvider.searchResults.length ~/
                                            10 *
                                            10);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  child: const Text(
                                    "fetch more",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }
                      var searchResult = searchProvider.searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Slidable(
                          key: const ValueKey(0),
                          closeOnScroll: true,
                          groupTag: 1,
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.2,
                            children: [
                              SliderItemMusic(
                                track: searchResult,
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              Provider.of<MusicPlayerProvider>(context,
                                      listen: false)
                                  .addToQueue(searchResult, null);
                              Provider.of<MusicPlayerProvider>(context,
                                      listen: false)
                                  .play();
                            },
                            title: Text(
                              searchResult.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Row(children: [
                              searchResult.explicit != null &&
                                      searchResult.explicit == true
                                  ? Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3))),
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: const Text(
                                        "E",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 0,
                                    ),
                              SizedBox(
                                width: searchResult.explicit != null &&
                                        searchResult.explicit == true
                                    ? 5
                                    : 0,
                              ),
                              Expanded(
                                child: Text(
                                  flattenArtistName(searchResult.artists),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.6),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ),
                              ),
                            ]),
                            leading: Image.network(
                                searchResult.album!.images?[0].url ?? ''),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
