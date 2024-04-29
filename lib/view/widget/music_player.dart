import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/view/music_detail_screens.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (context, musicPlayerProvider, child) {
        return musicPlayerProvider.currentTrack != null
            ? GestureDetector(
                onTap: () {
                  context.push(MusicDetailScreens.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: musicPlayerProvider.currentTrackColor,
                                spreadRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Display the album cover image
                              musicPlayerProvider.currentTrack?.album?.images
                                          ?.isNotEmpty ??
                                      false
                                  ? Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              musicPlayerProvider
                                                      .currentTrack!
                                                      .album!
                                                      .images!
                                                      .first
                                                      .url ??
                                                  ""),
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: musicPlayerProvider
                                                .currentTrackColor,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Icon(Icons.music_note,
                                      size:
                                          30), // Placeholder if no image is available
                              const SizedBox(
                                  width: 10), // Spacer between image and text
                              // Display track and artist name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      musicPlayerProvider.currentTrack?.name ??
                                          "Unknown Track",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Expanded(
                                      child: Text(
                                        flattenArtistName(musicPlayerProvider
                                            .currentTrack?.artists),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
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
                              ),
                            ],
                          )),
                      StreamBuilder(
                          stream:
                              musicPlayerProvider.audioPlayer.onPositionChanged,
                          builder: (context, snapshots) {
                            if (snapshots.hasData &&
                                snapshots.data! ==
                                    musicPlayerProvider.totalDuration) {
                              // If the current position is greater than or equal to total duration, play next song
                              musicPlayerProvider.next();
                            }
                            return ProgressBar(
                              progress:
                                  snapshots.data ?? const Duration(seconds: 0),
                              total: musicPlayerProvider.totalDuration,
                              timeLabelLocation: TimeLabelLocation.none,
                              bufferedBarColor: Colors.white38,
                              baseBarColor: Colors.white10,
                              thumbColor: Colors.transparent,
                              progressBarColor: Colors.white,
                              onSeek: (duration) {
                                musicPlayerProvider.seek(duration);
                              },
                            );
                          }),
                    ],
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
