import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/view/full_lyric.dart';
import 'package:spotify_clone/view/widget/stream_lyric.dart';

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HSLColor.fromColor(musicPlayerProvider.currentTrackColor)
                      .withLightness(0.6)
                      .toColor(),
                  HSLColor.fromColor(musicPlayerProvider.currentTrackColor)
                      .withLightness(0.8)
                      .toColor(),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
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
                            navigatorKey.currentState?.pushNamed(
                                FullLyricScreens.id,
                                arguments: musicPlayerProvider);
                          },
                          icon: const Icon(CupertinoIcons.fullscreen),
                        ),
                      ),
                    ]),
                const SizedBox(height: 10),
                SizedBox(
                    height: 200,
                    child: musicPlayerProvider.lyric != null
                        ? StreamLyric(
                            musicPlayerProvider: musicPlayerProvider,
                          )
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
