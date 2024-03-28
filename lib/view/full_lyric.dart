import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/view/widget/stream_lyric.dart';

class FullLyricScreens extends StatefulWidget {
  static const String id = 'full_lyric_screens';
  final MusicPlayerProvider musicPlayerProvider;

  const FullLyricScreens({super.key, required this.musicPlayerProvider});

  @override
  _FullLyricScreensState createState() => _FullLyricScreensState();
}

class _FullLyricScreensState extends State<FullLyricScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          HSLColor.fromColor(widget.musicPlayerProvider.currentTrackColor)
              .withLightness(0.6)
              .toColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Row(
          children: <Widget>[
            Icon(Icons.search, color: Colors.white),
            SizedBox(
              width: 10,
            ),
            Text(
              'Search',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
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
            Flexible(
              flex: 1,
              child: widget.musicPlayerProvider.lyric != null
                  ? SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: StreamLyric(
                            musicPlayerProvider: widget.musicPlayerProvider,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No lyric available',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ))),
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
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.skip_next),
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
