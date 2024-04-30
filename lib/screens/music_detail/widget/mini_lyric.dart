import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/view/full_lyric_screen.dart';
import 'package:spotify_clone/widget/stream_lyric.dart';

class MiniLyric extends StatefulWidget {
  const MiniLyric({super.key});

  @override
  State<MiniLyric> createState() => _MiniLyricState();
}

class _MiniLyricState extends State<MiniLyric> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
        builder: (context, musicPlayerProvider, child) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: musicPlayerProvider.lyric?.colors.background != null
                  ? Color(
                      int.parse(musicPlayerProvider.lyric!.colors.background),
                    )
                  : musicPlayerProvider.currentTrackColor,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lyric",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                      Transform.rotate(
                        angle: pi / 2,
                        child: IconButton(
                          onPressed: () {
                            context.push(FullLyricScreens.id,
                                extra: musicPlayerProvider);
                          },
                          icon: const Icon(CupertinoIcons.fullscreen),
                        ),
                      ),
                    ]),
                const SizedBox(height: 10),
                SizedBox(
                    height: 250,
                    child: musicPlayerProvider.lyric != null
                        ? const StreamLyric()
                        : Center(
                            child: Text(
                            'No lyric available',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ))),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      );
    });
  }
}