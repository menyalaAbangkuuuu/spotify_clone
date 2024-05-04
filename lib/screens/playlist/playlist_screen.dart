import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotify/spotify.dart' hide Image, Offset;
import 'package:spotify_clone/screens/search_music/widget/search_item_music.dart';

import '../../services/spotify.dart';

class PlaylistScreen extends StatefulWidget {
  static const routeName = '/playlist';

  final String playlistId;

  const PlaylistScreen({
    super.key,
    required this.playlistId,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpotifyService.getPlaylistById(widget.playlistId),
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
          final playlistData = snapshot.data;
          final tracks = playlistData?.playlist.tracks?.itemsNative?.toList()
              as List<Track>;

          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                controller: _controller,
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.35,
                    pinned: true,
                    stretch: true,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        var top = constraints.biggest.height;
                        return top > 90
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      playlistData?.backgroundColor
                                              ?.withOpacity(0.6) ??
                                          Colors.black,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(30),
                                alignment: Alignment.center,
                                child: CachedNetworkImage(
                                  imageUrl: playlistData
                                          ?.playlist.images?.first.url ??
                                      "",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Image(image: imageProvider),
                                  ),
                                  fit: BoxFit.cover,
                                ))
                            : Container(
                                alignment: Alignment.center,
                                color: playlistData?.backgroundColor
                                    ?.withOpacity(0.7),
                                child: Text(playlistData?.playlist.name ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              );
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: MySliverPersistentHeaderDelegate(),
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      int trackIndex = index;
                      final track = tracks[trackIndex];
                      return searchItemMusic(context,
                          track: track,
                          isFromPlaylist: true,
                          currentIndex: index,
                          tracks: tracks);
                    }, childCount: tracks.length),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60.0;

  @override
  double get maxExtent => 60.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.play),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.random),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsisH),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
