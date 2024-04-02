import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/view/queue_list_screen.dart';
import 'package:spotify_clone/view/search_screens.dart';
import 'package:spotify_clone/view/widget/mini_lyric.dart';

class MusicDetailScreens extends StatefulWidget {
  static const id = '/music_detail';
  const MusicDetailScreens({super.key});

  @override
  State<MusicDetailScreens> createState() => _MusicDetailScreensState();
}

class _MusicDetailScreensState extends State<MusicDetailScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              Provider.of<MusicPlayerProvider>(context).currentTrack?.name ??
                  ""),
          backgroundColor:
              Provider.of<MusicPlayerProvider>(context).currentTrackColor,
          leading: IconButton(
            icon: Transform.rotate(
              angle: pi / 2,
              child: const Icon(Icons.arrow_forward_ios),
            ),
            onPressed: () {
              context.go(SearchScreens.id);
            },
          ),
        ),
        body: Consumer<MusicPlayerProvider>(
            builder: (context, musicPlayerProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  musicPlayerProvider.currentTrackColor,
                  musicPlayerProvider.currentTrackColor.withOpacity(0.5),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: musicPlayerProvider.currentTrack?.album
                                        ?.images?.first.url !=
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
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder(
                        stream:
                            musicPlayerProvider.audioPlayer.onPositionChanged,
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
                        StreamBuilder(
                            stream: musicPlayerProvider
                                .audioPlayer.onPlayerComplete,
                            builder: (context, snapshot) {
                              return IconButton(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          CupertinoIcons.share_up,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () =>
                                context.push(QueueListScreen.routeName),
                            icon: const Icon(
                              Icons.queue_music,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const MiniLyric()
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
