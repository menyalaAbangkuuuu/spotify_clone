import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
      _debounce!.cancel(); // Cancel any existing timer
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
              autocorrect: false,
              cursorColor: Colors.white,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
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
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white, size: 20),
                suffixIcon: !_isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            _isEmpty = true;
                          });
                        },
                      )
                    : null,
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
                      .bodySmall
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
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
                          child: Consumer<MusicPlayerProvider>(
                            builder: (context, musicPlayerProvider, child) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (musicPlayerProvider
                                    .errorMessage.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          musicPlayerProvider.errorMessage),
                                      backgroundColor: Colors.red[600],
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  musicPlayerProvider.clearError();
                                }
                              });
                              return ListTile(
                                onTap: () {
                                  musicPlayerProvider.addToQueue(
                                      searchResult, null);
                                  musicPlayerProvider.play();
                                },
                                title: Text(
                                  searchResult.name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
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
                                          child: Text(
                                            "E",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
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
                                          .titleSmall
                                          ?.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                  ),
                                ]),
                                leading: CachedNetworkImage(
                                  height: 40,
                                  imageUrl:
                                      searchResult.album!.images?[0].url ?? '',
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.white,
                                    child: const SizedBox(
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              );
                            },
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
