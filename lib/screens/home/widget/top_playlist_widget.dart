import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' as spotify;
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
        spotify.PlaylistSimple track = musicProvider.topTracks![index];
        // Create a list tile for each track
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the start
            children: [
              ListTile(
                title: Text(track.name ?? ""), // Display the track's name
                // You can add more properties here, like leading icons, subtitles, etc.
              ),
              // Add an image widget below the ListTile
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0), // Menambahkan padding horizontal
                child: track.images != null && track.images!.isNotEmpty
                    ? Image.network(track.images!.first.url ?? "",
                        fit: BoxFit.cover)
                    : Container(),
              ),
              // Add some spacing between the ListTile and the image
              const SizedBox(height: 8.0),
              // Add text below the image
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Text(track.description ?? "No description available"),
              ),
            ],
          ),
        );
      },
    );
  }
}
