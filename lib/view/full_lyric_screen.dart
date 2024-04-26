import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/view/widget/stream_lyric.dart';

class FullLyricScreens extends StatefulWidget {
  static const String id = '/full_lyric';
  final MusicPlayerProvider musicPlayerProvider;

  const FullLyricScreens({super.key, required this.musicPlayerProvider});

  @override
  _FullLyricScreensState createState() => _FullLyricScreensState();
}

class _FullLyricScreensState extends State<FullLyricScreens> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(int.parse(widget.musicPlayerProvider.lyric!.colors.background)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Transform.rotate(
            angle: pi / 2,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          onPressed: () {
            context.pop();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.musicPlayerProvider.currentTrack?.name ?? "",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              flattenArtistName(
                      widget.musicPlayerProvider.currentTrack?.artists) ??
                  "",
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: widget.musicPlayerProvider.lyric != null
                  ? Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(10),
                      child: StreamLyric(
                        musicPlayerProvider: widget.musicPlayerProvider,
                      ),
                    )
                  : Center(
                      child: Text(
                        'No lyric available',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  StreamBuilder(
                      stream: widget
                          .musicPlayerProvider.audioPlayer.onPositionChanged,
                      builder: (context, snapshots) {
                        return ProgressBar(
                          progress: snapshots.data ??
                              widget.musicPlayerProvider.currentPosition,
                          total: widget.musicPlayerProvider.totalDuration,
                          timeLabelLocation: TimeLabelLocation.below,
                          bufferedBarColor: Colors.white38,
                          baseBarColor: Colors.white10,
                          thumbColor: Colors.white,
                          progressBarColor: Colors.white,
                          onSeek: (duration) {
                            widget.musicPlayerProvider.seek(duration);
                          },
                        );
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.skip_previous),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                      StreamBuilder(
                          stream: widget.musicPlayerProvider.audioPlayer
                              .onPositionChanged,
                          builder: (context, snapshot) {
                            return IconButton(
                              onPressed: () {
                                widget.musicPlayerProvider.isPlaying
                                    ? widget.musicPlayerProvider.pause()
                                    : widget.musicPlayerProvider.resume();
                              },
                              icon: widget.musicPlayerProvider.isPlaying
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                              iconSize: 40,
                              color: Colors.white,
                            );
                          }),
                      IconButton(
                        onPressed: () {
                          widget.musicPlayerProvider.next();
                        },
                        icon: const Icon(Icons.skip_next),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
