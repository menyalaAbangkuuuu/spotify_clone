import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';

Column musicPlayer(
    BuildContext context, MusicPlayerProvider musicPlayerProvider,
    {bool withNextPrevButton = true}) {
  return Column(
    children: [
      StreamBuilder(
          stream: musicPlayerProvider.audioPlayer.onPositionChanged,
          builder: (context, snapshots) {
            return ProgressBar(
              progress: snapshots.data ?? musicPlayerProvider.currentPosition,
              total: musicPlayerProvider.totalDuration,
              timeLabelLocation: TimeLabelLocation.below,
              bufferedBarColor: Colors.white38,
              thumbRadius: 5,
              barHeight: 4,
              baseBarColor: Colors.white10,
              thumbColor: Colors.white,
              timeLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
              timeLabelType: TimeLabelType.remainingTime,
              progressBarColor: Colors.white,
              onSeek: (duration) {
                musicPlayerProvider.seek(duration);
              },
            );
          }),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          withNextPrevButton
              ? IconButton(
                  onPressed: musicPlayerProvider.canPrev
                      ? () => musicPlayerProvider.prev()
                      : null,
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 40,
                  color: Colors.white,
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {
              if (musicPlayerProvider.isPlaying) {
                musicPlayerProvider.pause();
              } else {
                musicPlayerProvider.resume();
              }
            },
            icon: Icon(
              musicPlayerProvider.isPlaying
                  ? CupertinoIcons.pause_fill
                  : CupertinoIcons.play_fill,
            ),
            color: Colors.black.withOpacity(.7),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(50, 50)),
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(15),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                const CircleBorder(),
              ),
            ),
          ),
          withNextPrevButton
              ? IconButton(
                  onPressed: musicPlayerProvider.canNext
                      ? () => musicPlayerProvider.next()
                      : null,
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 40,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ],
      ),
    ],
  );
}
