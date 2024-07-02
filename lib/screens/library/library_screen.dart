import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotify_clone/services/spotify.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = '/library';

  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Library',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: SpotifyService.getPlaylistFromUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: Colors.white,
                        size: 48,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final playlistData = snapshot.data;
                    return ListView.builder(
                      itemCount: playlistData?.length,
                      itemBuilder: (context, index) {
                        final playlist = playlistData?[index];
                        return ListTile(
                          leading: Icon(Icons.music_note),
                          title: Text(playlist?.name ?? ""),
                          subtitle:
                              Text(playlist?.description ?? 'No description'),
                          onTap: () {
                            // Navigate to playlist detail or play the playlist
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No playlists found'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
