import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify/spotify.dart';

import '../providers/music_player_provider.dart';
import '../services/spotify.dart';
import '../utils/flatten_artists_name.dart';

class PlaylistDetailScreen extends StatelessWidget {
  static const routeName = '/playlist_detail';

  final String playlistId;
  final String playlistName;
  final String playlistImage;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.playlistImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, SpotifyService spotifyService, child) {
          return FutureBuilder(
            future: SpotifyService.getMusicByPlaylist(playlistId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final playlist = snapshot.data;
                print(playlist?.first.name);
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
                                    imageUrl: playlistImage,
                                    fit: BoxFit.cover,
                                  )
                                : Text(
                                    playlistName,
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
                          final track = playlist?[index];
                          return ListTile(
                            onTap: () {
                              Provider.of<MusicPlayerProvider>(context,
                                      listen: false)
                                  .addToQueue(track!, null);
                              Provider.of<MusicPlayerProvider>(context,
                                      listen: false)
                                  .play();
                            },
                            title: Text(
                              track?.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Row(children: [
                              track?.explicit != null && track!.explicit == true
                                  ? Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3))),
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: const Text(
                                        "E",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 0,
                                    ),
                              SizedBox(
                                width: track?.explicit != null &&
                                        track?.explicit == true
                                    ? 5
                                    : 0,
                              ),
                              Expanded(
                                child: Text(
                                  flattenArtistName(track?.artists),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.6),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ),
                              ),
                            ]),
                            leading: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: track?.album?.images?.first.url ?? "",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.black.withOpacity(.5),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.black.withOpacity(.6),
                                  height: 50.0,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: playlist?.length,
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
