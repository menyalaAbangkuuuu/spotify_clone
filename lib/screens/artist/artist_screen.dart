import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/model/artist_detail.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/screens/search_music/widget/search_item_music.dart';
import 'package:spotify_clone/services/spotify.dart';
import 'package:spotify_clone/widget/mini_player.dart';

class ArtistScreen extends StatelessWidget {
  static const routeName = '/artist';
  final String artistId;
  final ScrollController _controller = ScrollController();

  ArtistScreen({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<ArtistDetail>(
                future: SpotifyService.getArtistData(artistId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final artistDetail = snapshot.data!;
                  return CustomScrollView(
                    controller: _controller,
                    slivers: [
                      SliverAppBar(
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.35,
                        pinned: true,
                        stretch: true,
                        flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            var top = constraints.biggest.height;
                            return Container(
                              height: top,
                              child: top > 90
                                  ? Container(
                                      padding: const EdgeInsets.all(30),
                                      alignment: Alignment.center,
                                      child: CachedNetworkImage(
                                        imageUrl: artistDetail
                                                .artist.images?.first.url ??
                                            "",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Image(image: imageProvider),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        artistDetail.artist.name ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(artistDetail.artist.name ?? ""),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SliverStickyHeader(
                        header: Align(
                          alignment: Alignment.centerRight,
                          child: Consumer<MusicPlayerProvider>(
                            builder: (context, musicPlayerProvider, _) {
                              return IconButton(
                                iconSize: 56,
                                icon: Icon(
                                  musicPlayerProvider.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  if (musicPlayerProvider.isPlaying) {
                                    musicPlayerProvider.pause();
                                  } else {
                                    musicPlayerProvider.addFromPlaylist(
                                        artistDetail.topTracks, 0);
                                    musicPlayerProvider.play();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        sliver: SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            final track = artistDetail.topTracks[index];
                            return searchItemMusic(context,
                                track: track,
                                isFromPlaylist: true,
                                currentIndex: index,
                                tracks: artistDetail.topTracks);
                          }, childCount: artistDetail.topTracks.length),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const MiniPlayer()
          ],
        ),
      ),
    );
  }
}
