import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/playlist_provider.dart';
import 'package:spotify_clone/view/widget/playlist_tile.dart';

class Library extends StatelessWidget {
  static const String id = "/library";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Your Library')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangeNotifierProvider(
              create: (context) => PlaylistProvider(),
              child: Consumer<PlaylistProvider>(
                builder: (context, playlistProvider, _) {
                  if (playlistProvider.playlists == null ||
                      playlistProvider.playlists!.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    children: playlistProvider.playlists!
                        .map((playlist) => PlaylistTile(
                              title: playlist.name ?? '',
                              imageUrl: playlist.images?.isNotEmpty ?? false
                                  ? playlist.images!.first.url ?? ''
                                  : '', 
                              description: playlist.description ?? '',
                              onTap: () {
                                playlistProvider.selectPlaylist(playlist);
                                Navigator.pushNamed(
                                  context,
                                  '/playlist_detail',
                                );
                              },
                            ))
                        .toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
