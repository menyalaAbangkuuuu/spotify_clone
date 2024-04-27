import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/playlist_provider.dart';

class CategoryItemTile extends StatefulWidget {
  const CategoryItemTile({super.key});

  @override
  State<CategoryItemTile> createState() => _CategoryItemTileState();
}

class _CategoryItemTileState extends State<CategoryItemTile> {
  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    if (playlistProvider.playlists == null ||
        playlistProvider.playlists!.isEmpty) {
      return const Center(child: Text('Loading playlists...'));
    }
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Library')),
        body: const Text("Library Screen"));
  }
}
