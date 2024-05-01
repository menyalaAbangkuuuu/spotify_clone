import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';

import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/widget/music_player.dart';
import 'package:spotify_clone/widget/stream_lyric.dart';

class FullLyricScreens extends StatefulWidget {
  static const String id = '/full_lyric';

  const FullLyricScreens({super.key});

  @override
  State<FullLyricScreens> createState() => _FullLyricScreensState();
}

class _FullLyricScreensState extends State<FullLyricScreens> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (context, musicPlayerProvider, child) {
        return Scaffold(
          backgroundColor: musicPlayerProvider.lyric?.colors.background != null
              ? Color(
                  int.parse(musicPlayerProvider.lyric!.colors.background),
                )
              : musicPlayerProvider.currentTrackColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Transform.rotate(
                angle: pi / 2,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  musicPlayerProvider.currentTrack?.name ?? "",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  flattenArtistName(musicPlayerProvider.currentTrack?.artists),
                  style: Theme.of(context).textTheme.titleSmall,
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
                Expanded(
                  child: musicPlayerProvider.lyric != null
                      ? Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(10),
                          child: const StreamLyric(),
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
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: musicPlayer(context, musicPlayerProvider,
                      withNextPrevButton: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
