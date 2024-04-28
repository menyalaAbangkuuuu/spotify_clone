import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/view/widget/category_detail_tile.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const routeName = '/category_detail';

  final String id;
  final String categoryName;

  const CategoryDetailScreen({
    super.key,
    required this.id,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.categories == null ||
              categoryProvider.categories!.isEmpty) {
            return const Center(child: Text('Loading playlists...'));
          }

          return FutureBuilder(
            future: categoryProvider.getPlaylistsByCategoryId(id ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('An error occurred!'));
              }

              final playlists = snapshot.data as List<PlaylistSimple>;

              if (playlists.isEmpty) {
                return const Center(child: Text('No playlists available.'));
              }

              return ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return FutureBuilder<Playlist>(
                    future: categoryProvider.getPlaylistFromSimple(playlist),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.data != null) {
                          return CategoryDetailTile(playlist: snapshot.data!);
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
