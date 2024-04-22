import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/playlist_provider.dart';
import 'package:spotify_clone/view/playlist_screen.dart';

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
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        categoryName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, _) {
        if (playlistProvider.playlists == null ||
            playlistProvider.playlists!.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: playlistProvider.playlists!.length,
          itemBuilder: (context, index) {
            final playlist = playlistProvider.playlists![index];
            return ListTile(
              title: Text(playlist.name ?? 'Unknown'),
              subtitle: Text(playlist.description ?? ''),
              onTap: () {
                context.push(
                  PlaylistScreen.routeName,
                );
              },
            );
          },
        );
      },
    );
  }
}
