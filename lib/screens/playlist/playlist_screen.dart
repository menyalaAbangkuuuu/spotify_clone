import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/screens/search_music/widget/search_item_music.dart';

import '../../services/spotify.dart';

class PlaylistScreen extends StatelessWidget {
  static const routeName = '/playlist';

  final String playlistId;

  const PlaylistScreen({
    super.key,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SpotifyService.getPlaylistById(playlistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.waveDots(
                    color: Colors.white, size: 48));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final playlist = snapshot.data;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  pinned: true,
                  floating: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      var top = constraints.biggest.height;
                      return Container(
                        alignment: Alignment.center,
                        child: top > 80
                            ? CachedNetworkImage(
                                imageUrl: playlist?.images?.first.url ?? "",
                                fit: BoxFit.cover,
                              )
                            : Text(
                                playlist?.name ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                      );
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = playlist?.tracks?.itemsNative
                          ?.toList()[index] as Track;
                      return searchItemMusic(context, track: track);
                    },
                    childCount: playlist?.tracks?.itemsNative?.length ?? 0,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
