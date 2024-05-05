import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/search_music_provider.dart';
import 'package:spotify_clone/screens/search_music/widget/search_item_music.dart';

class SearchMusicScreen extends StatefulWidget {
  static const String routeName = '/search_music';

  const SearchMusicScreen({super.key});

  @override
  State<SearchMusicScreen> createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        context.read<SearchProvider>().canLoadMore == true) {
      context.read<SearchProvider>().fetchMore(_searchController.text,
          context.read<SearchProvider>().searchResults.length ~/ 10 * 10);
    }
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
          _scrollController.jumpTo(0);
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
                    )),
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
                    controller: _scrollController,
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
                      return searchItemMusic(context,
                          track: searchResult, currentIndex: index);
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
