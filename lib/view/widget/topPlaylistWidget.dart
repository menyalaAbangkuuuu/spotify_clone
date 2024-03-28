import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/providers/music_provider.dart';

class TopTracksWidget extends StatelessWidget {
  const TopTracksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the MusicProvider
    final musicProvider = Provider.of<MusicProvider>(context);

    // Check if topTracks is null or empty to show a loading or empty message
    if (musicProvider.topTracks == null || musicProvider.topTracks!.isEmpty) {
      return const Center(child: Text('Loading top playlists...'));
    }

    // Use ListView.builder to display each track
    return ListView.builder(
      itemCount:
          musicProvider.topTracks!.length, // The count of items in the list
      itemBuilder: (context, index) {
        // Get the current track
        PlaylistSimple track = musicProvider.topTracks![index];

        // Create a list tile for each track
        return ListTile(
          title: Text(track.name ?? ""), // Display the track's name
          // You can add more properties here, like leading icons, subtitles, etc.
        );
      },
    );
  }
}
