import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';

class MusicDetailScreens extends StatefulWidget {
  static const id = 'music_detail_screens';
  const MusicDetailScreens({super.key});

  @override
  State<MusicDetailScreens> createState() => _MusicDetailScreensState();
}

class _MusicDetailScreensState extends State<MusicDetailScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music Detail Screens'),
          backgroundColor:
              Provider.of<MusicPlayerProvider>(context).currentTrackColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_downward_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Consumer<MusicPlayerProvider>(
            builder: (context, musicPlayerProvider, child) {
          return Container(
            decoration: BoxDecoration(
              color: musicPlayerProvider.currentTrackColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: musicPlayerProvider
                                      .currentTrack?.album?.images?.first.url !=
                                  null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(musicPlayerProvider
                                          .currentTrack
                                          ?.album
                                          ?.images!
                                          .first
                                          .url! ??
                                      ""),
                                )
                              : null),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    musicPlayerProvider.currentTrack?.name ?? '',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    flattenArtistName(
                        musicPlayerProvider.currentTrack?.artists),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder(
                      stream: musicPlayerProvider.audioPlayer.onPositionChanged,
                      builder: (context, snapshots) {
                        return ProgressBar(
                          progress: snapshots.data ??
                              musicPlayerProvider.currentPosition,
                          total: musicPlayerProvider.totalDuration,
                          timeLabelLocation: TimeLabelLocation.below,
                          bufferedBarColor: Colors.white38,
                          baseBarColor: Colors.white10,
                          thumbColor: Colors.white,
                          progressBarColor: Colors.white,
                          onSeek: (duration) {
                            musicPlayerProvider.seek(duration);
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
                      IconButton(
                        onPressed: () {
                          musicPlayerProvider.isPlaying
                              ? musicPlayerProvider.pause()
                              : musicPlayerProvider.resume();
                        },
                        icon: musicPlayerProvider.isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.skip_next),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }));
  }
}
