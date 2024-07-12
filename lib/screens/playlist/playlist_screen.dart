import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' hide Offset, Image;
import 'package:spotify_clone/model/playlist_extension.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/screens/playlist/widget/add_song_drawer.dart';
import 'package:spotify_clone/screens/search_music/widget/search_item_music.dart';
import 'package:spotify_clone/services/spotify.dart';
import 'package:spotify_clone/utils/format_duration.dart';

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

  late Future<PlaylistWithBackground> _futurePlaylist;

  @override
  void initState() {
    super.initState();
    _fetchPlaylist();
  }

  void _fetchPlaylist() {
    setState(() {
      _futurePlaylist = SpotifyService.getPlaylistById(widget.playlistId);
    });
  }

  void _showBottomDrawer(BuildContext context, String playlistId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.9,
          minChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Add to this Playlist',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: AddSongDrawer(
                    playlistId: playlistId,
                    onAdded: () {
                      _fetchPlaylist();
                    },
                  )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return FutureBuilder<PlaylistWithBackground>(
      future: _futurePlaylist,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.waveDots(
                  color: Colors.white, size: 48));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final playlistData = snapshot.data as PlaylistWithBackground;
          final tracks = playlistData.playlist.tracks?.itemsNative?.toList()
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
                                      playlistData.backgroundColor
                                              ?.withOpacity(0.6) ??
                                          Colors.black,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(30),
                                alignment: Alignment.center,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      playlistData.playlist.images?.first.url ??
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
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
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
                                    child: const Icon(
                                      Icons.music_note_outlined,
                                      size: 100,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ))
                            : Container(
                                alignment: Alignment.center,
                                color: playlistData.backgroundColor
                                    ?.withOpacity(0.7),
                                child: Text(
                                  playlistData.playlist.name ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
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
                        Text(playlistData.playlist.description ?? ""),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.spotify,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              playlistData.playlist.owner?.displayName ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            '${NumberFormat.compact().format(playlistData.playlist.followers?.total)} followers • ${formatDuration(tracks.fold(0, (int previousValue, element) => previousValue + (element.durationMs ?? 0)))}'),
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
                              musicPlayerProvider.isPlaying
                                  ? musicPlayerProvider.pause()
                                  : {
                                      musicPlayerProvider.addFromPlaylist(
                                          tracks, 0),
                                      musicPlayerProvider.play()
                                    };
                            },
                          );
                        },
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          if (auth.user?.id !=
                              playlistData.playlist.owner?.id) {
                            return const SizedBox.shrink();
                          } else {
                            if (tracks.isEmpty) {
                              return Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.white)),
                                      onPressed: () {
                                        _showBottomDrawer(
                                            context, widget.playlistId);
                                      },
                                      child: const Text("add to this playlist",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold))),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () => _showBottomDrawer(
                                      context, widget.playlistId),
                                  leading: Container(
                                    color: Colors.grey.shade700,
                                    height: 50,
                                    width: 50,
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  title: const Text("add to this playlist"),
                                ),
                              );
                            }
                          }
                        }

                        int trackIndex = index - 1;
                        final track = tracks[trackIndex];

                        return searchItemMusic(
                          context,
                          track: track,
                          isFromPlaylist: true,
                          currentIndex: trackIndex,
                          tracks: tracks,
                        );
                      }, childCount: tracks.length + 1),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
