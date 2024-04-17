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
    return Container();
  }
}
