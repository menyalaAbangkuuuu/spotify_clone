import 'package:flutter/material.dart';

class PlaylistDetailScreen extends StatelessWidget {
  static const routeName = '/playlist_detail';

  final String playlistId;
  final String playlistName;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: Center(
        child: Text('Playlist Detail Screen for $playlistName'),
      ),
    );
  }
}
