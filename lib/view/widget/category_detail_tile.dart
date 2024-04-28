import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' hide Image;

class CategoryDetailTile extends StatelessWidget {
  final List<PlaylistSimple> playlists;

  const CategoryDetailTile({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlists.length, // The count of items in the list
      itemBuilder: (context, index) {
        final currentPlaylist = playlists[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the start
            children: [
              ListTile(
                title: Text(currentPlaylist.name ?? ""),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: currentPlaylist.images != null &&
                        currentPlaylist.images!.isNotEmpty
                    ? Image.network(currentPlaylist.images!.first.url ?? "",
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
                child: Text(
                    currentPlaylist.description ?? "No description available"),
              ),
            ],
          ),
        );
      },
    );
    ;
  }
}
