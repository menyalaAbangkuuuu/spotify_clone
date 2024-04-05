import 'dart:math';

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
    return StreamBuilder(
        stream: widget.musicPlayerProvider.audioPlayer.onPositionChanged,
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            Duration? currentDuration = snapshots.data;
            int lastIndex = -1;

            for (int i = 0;
                i < widget.musicPlayerProvider.lyric!.lyrics.lines.length;
                i++) {
              if (widget
                      .musicPlayerProvider.lyric!.lyrics.lines[i].startTimeMs <=
                  currentDuration!.inMilliseconds) {
                lastIndex = i;
              } else {
                break;
              }
            }

            if (_currentLyricIndex != lastIndex) {
              _currentLyricIndex = lastIndex;
              final scrollToIndex = max(lastIndex - 1, 0);
              final maxIndex =
                  widget.musicPlayerProvider.lyric!.lyrics.lines.length;

              if (itemScrollController.isAttached) {
                itemScrollController.scrollTo(
                  index: min(scrollToIndex, maxIndex),
                  alignment: _currentLyricIndex < 4
                      ? 0.0
                      : _currentLyricIndex + 3 < maxIndex
                          ? 0.2
                          : 0.7,
                  duration: const Duration(milliseconds: 200),
                );
              }
            }

            return Stack(children: [
              ScrollablePositionedList.builder(
                itemCount:
                    widget.musicPlayerProvider.lyric!.lyrics.lines.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  bool isCurrent = index == _currentLyricIndex;
                  bool isPast = index < _currentLyricIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        widget.musicPlayerProvider.audioPlayer.seek(Duration(
                            milliseconds: widget.musicPlayerProvider.lyric!
                                .lyrics.lines[index].startTimeMs));
                      },
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isPast
                              ? Colors.white.withOpacity(0.7)
                              : isCurrent
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        child: Text(
                          widget.musicPlayerProvider.lyric!.lyrics.lines[index]
                              .words,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemScrollController: itemScrollController,
                scrollOffsetController: scrollOffsetController,
                itemPositionsListener: itemPositionsListener,
                scrollOffsetListener: scrollOffsetListener,
              ),
              Positioned(
                right: 0,
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(int.parse(widget
                                .musicPlayerProvider.lyric!.colors.background))
                            .withOpacity(0.5),
                        Color(int.parse(widget
                            .musicPlayerProvider.lyric!.colors.background))
                      ],
                    ),
                  ),
                  height: 30,
                  width: 100,
                ),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(int.parse(widget.musicPlayerProvider.lyric!
                                  .colors.background))
                              .withOpacity(0.5),
                          Color(int.parse(widget
                              .musicPlayerProvider.lyric!.colors.background))
                        ],
                      ),
                    ),
                    height: 30,
                    width: 100,
                  )),
            ]);
          }
          return const SizedBox();
        });
  }
}
