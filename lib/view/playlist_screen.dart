import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  static const routeName = '/playlist';

  const PlaylistScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Playlist Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
