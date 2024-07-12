import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' hide Image, Offset;
import 'package:spotify_clone/screens/search_music/widget/search_item_music.dart';

import '../../providers/music_player_provider.dart';
import '../../services/spotify.dart';

// TODO buat penjelasan
class SavedSongScreen extends StatefulWidget {
  static const routeName = '/savedSong';

  const SavedSongScreen({
    super.key,
  });

  @override
  State<SavedSongScreen> createState() => _SavedSongScreenState();
}

class _SavedSongScreenState extends State<SavedSongScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpotifyService.getUserSavedTracks(),
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
          final playlistData = snapshot.data as List<TrackSaved>;
          final tracks = playlistData.toList();

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
                                alignment: Alignment.center,
                                color: Colors.red,
                                child: const Text("Saved Songs",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              )
                            : Container(
                                alignment: Alignment.center,
                                color: Colors.red,
                                child: const Text("Saved Songs",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              );
                      },
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
                                          tracks.cast<Track>(), 0),
                                      musicPlayerProvider.play()
                                    };
                            },
                          );
                        },
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        int trackIndex = index;
                        final track = tracks[trackIndex];
                        return searchItemMusic(context,
                            track: track.track!,
                            isFromPlaylist: true,
                            currentIndex: index,
                            tracks: tracks.map((e) => e.track!).toList());
                      }, childCount: tracks.length),
                    ),
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
