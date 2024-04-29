import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StreamLyric extends StatefulWidget {
  const StreamLyric({super.key});

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
    return Consumer<MusicPlayerProvider>(
        builder: (context, musicPlayerProvider, child) {
      return StreamBuilder(
          stream: musicPlayerProvider.audioPlayer.onPositionChanged,
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              Duration? currentDuration = snapshots.data;
              int lastIndex = -1;

              for (int i = 0;
                  i < musicPlayerProvider.lyric!.lyrics.lines.length;
                  i++) {
                if (musicPlayerProvider.lyric!.lyrics.lines[i].startTimeMs <=
                    currentDuration!.inMilliseconds) {
                  lastIndex = i;
                } else {
                  break;
                }
              }

              if (_currentLyricIndex != lastIndex) {
                _currentLyricIndex = lastIndex;
                final scrollToIndex = max(lastIndex - 1, 0);
                final maxIndex = musicPlayerProvider.lyric!.lyrics.lines.length;

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
                  itemCount: musicPlayerProvider.lyric!.lyrics.lines.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    bool isCurrent = index == _currentLyricIndex;
                    bool isPast = index < _currentLyricIndex;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          musicPlayerProvider.seek(Duration(
                              milliseconds: musicPlayerProvider
                                  .lyric!.lyrics.lines[index].startTimeMs));
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: isPast
                                        ? Colors.white.withOpacity(0.7)
                                        : isCurrent
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                          child: Text(
                            musicPlayerProvider
                                .lyric!.lyrics.lines[index].words,
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
                          Color(int.parse(musicPlayerProvider
                                      .lyric?.colors.background ??
                                  "0xFF000000"))
                              .withOpacity(0.5),
                          Color(int.parse(
                              musicPlayerProvider.lyric?.colors.background ??
                                  "0xFF000000"))
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
                            Color(int.parse(musicPlayerProvider
                                    .lyric!.colors.background))
                                .withOpacity(0.5),
                            Color(int.parse(
                                musicPlayerProvider.lyric!.colors.background))
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
    });
  }
}
