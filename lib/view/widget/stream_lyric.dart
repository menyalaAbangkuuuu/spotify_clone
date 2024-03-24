import 'package:flutter/material.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StreamLyric extends StatefulWidget {
  final MusicPlayerProvider musicPlayerProvider;
  const StreamLyric({super.key, required this.musicPlayerProvider});

  @override
  State<StreamLyric> createState() => _StreamLyricState();
}

class _StreamLyricState extends State<StreamLyric> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  int _currentLyricIndex = -1;
  @override
  Widget build(BuildContext context) {
    return widget.musicPlayerProvider.lyric!.lines.isNotEmpty &&
            widget.musicPlayerProvider.lyric != null
        ? StreamBuilder(
            stream: widget.musicPlayerProvider.audioPlayer.onPositionChanged,
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                Duration? currentDuration = snapshots.data;
                int lastIndex = -1;
                for (int i = 0;
                    i < widget.musicPlayerProvider.lyric!.lines.length;
                    i++) {
                  if (int.parse(widget
                          .musicPlayerProvider.lyric!.lines[i].startTimeMs) <=
                      currentDuration!.inMilliseconds) {
                    lastIndex = i;
                  } else {
                    // Once you find a line that starts after the current time, stop the loop.
                    break;
                  }
                }

                // Use lastIndex instead of currentIndex from here on
                if (_currentLyricIndex != lastIndex) {
                  _currentLyricIndex = lastIndex;
                  if (lastIndex >= 0 && itemScrollController.isAttached) {
                    itemScrollController.scrollTo(
                      index: lastIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  }
                }

                return ScrollablePositionedList.builder(
                  itemCount: widget.musicPlayerProvider.lyric!.lines.length,
                  itemBuilder: (context, index) {
                    Duration duration =
                        snapshots.data ?? const Duration(seconds: 0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.musicPlayerProvider.audioPlayer.seek(Duration(
                              milliseconds: int.parse(widget.musicPlayerProvider
                                  .lyric!.lines[index].startTimeMs)));
                        },
                        child: Text(
                          widget.musicPlayerProvider.lyric!.lines[index].words,
                          style: TextStyle(
                            color: int.parse(widget.musicPlayerProvider.lyric!
                                        .lines[index].startTimeMs) <=
                                    duration.inMilliseconds.toInt()
                                ? Colors.white
                                : Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  itemScrollController: itemScrollController,
                  scrollOffsetController: scrollOffsetController,
                  itemPositionsListener: itemPositionsListener,
                  scrollOffsetListener: scrollOffsetListener,
                );
              }
              return const SizedBox();
            })
        : const SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'No lyrics found.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ));
  }
}
