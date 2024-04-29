import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/services/spotify.dart';
import 'package:spotify_clone/view/widget/category_detail_tile.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const routeName = '/category';

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
      body: FutureBuilder(
        future: SpotifyService.getCategoryPlaylists(id),
        builder: (context, snapshot) {
          print("hello");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return CategoryDetailTile(playlists: snapshot.data!);
          }
        },
      ),
    );
  }
}
