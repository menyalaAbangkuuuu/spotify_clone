import 'package:flutter/material.dart';

class PlaylistDetailScreenArguments {
  final String playlistId;
  final String playlistName;

  PlaylistDetailScreenArguments({
    required this.playlistId,
    required this.playlistName,
  });
}

class PlaylistDetailScreen extends StatelessWidget {
  static const routeName = '/playlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(),
    );
  }
}
