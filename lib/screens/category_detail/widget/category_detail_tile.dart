import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_clone/screens/playlist/playlist_screen.dart';

class CategoryDetailTile extends StatelessWidget {
  final List<PlaylistSimple> playlists;

  const CategoryDetailTile({required this.playlists, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final currentPlaylist = playlists[index];
        return GestureDetector(
          onTap: () {
            context.push('${PlaylistScreen.routeName}/${currentPlaylist.id}');
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(currentPlaylist.description ??
                      "No description available"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
