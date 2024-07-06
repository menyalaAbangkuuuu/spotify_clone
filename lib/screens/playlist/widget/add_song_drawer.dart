import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';
import 'package:spotify_clone/services/spotify.dart';

// TODO buat penjelasan
class AddSongDrawer extends StatefulWidget {
  final String playlistId;
  final Function onAdded;

  const AddSongDrawer(
      {super.key, required this.playlistId, required this.onAdded});

  @override
  State<AddSongDrawer> createState() => _AddSongDrawerState();
}

class _AddSongDrawerState extends State<AddSongDrawer> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll(_scrollController));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll(ScrollController scrollController) {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        context.read<SearchProvider>().canLoadMore == true) {
      context.read<SearchProvider>().fetchMore(_searchController.text,
          context.read<SearchProvider>().searchResults.length ~/ 10 * 10);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (query.isNotEmpty) {
          final searchProvider = context.read<SearchProvider>();

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
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                cursorColor: Colors.white,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
                controller: _searchController,
                autocorrect: false,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: const EdgeInsets.all(5),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  fillColor: Colors.grey.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: !_isEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isEmpty = true;
                            });
                          },
                        )
                      : null,
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .clearSearchResults();
                context.pop();
              },
              child: Text('Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white)),
            )
          ],
        ),
        const SizedBox(height: 10), // Add some spacing
        Expanded(
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (searchProvider.isLoading) {
                return Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: Colors.white,
                    size: 40,
                  ),
                );
              }
              if (searchProvider.searchResults.isEmpty) {
                return const Center(
                    child: Text('search for songs, artists, albums'));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: searchProvider.searchResults.length + 1,
                itemBuilder: (context, index) {
                  if (index >= searchProvider.searchResults.length) {
                    if (searchProvider.canLoadMore) {
                      return Center(
                        child: LoadingAnimationWidget.waveDots(
                            color: Colors.white, size: 40),
                      );
                    } else {
                      return const Center(child: Text("No more results"));
                    }
                  }
                  var searchResult = searchProvider.searchResults[index];
                  return ListTile(
                    title: Text(
                      searchResult.name ?? "",
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Text(searchResult.artists?.first.name ?? ""),
                    trailing: Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () async {
                      await SpotifyService.addSongToPlaylist(
                          widget.playlistId, searchResult.uri ?? "");
                      widget.onAdded();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Song added to playlist'),
                          ),
                        );
                      }
                    },
                    leading: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      imageUrl: searchResult.album?.images?.first.url ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.black.withOpacity(.5),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.black.withOpacity(.6),
                          height: 50.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.music_note_outlined,
                          size: 100,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
