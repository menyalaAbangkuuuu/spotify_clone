import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/screens/music_detail/widget/artist_card.dart';
import 'package:spotify_clone/screens/music_detail/widget/mini_lyric.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/screens/queue/queue_list_screen.dart';
import 'package:spotify_clone/widget/music_player.dart';

class MusicDetailScreen extends StatelessWidget {
  static const routeName = '/music_detail';

  const MusicDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
        builder: (context, musicPlayerProvider, _) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            musicPlayerProvider.currentTrack?.name ?? "",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          backgroundColor: musicPlayerProvider.currentTrackColor,
          leading: IconButton(
            icon: Transform.rotate(
              angle: pi / 2,
              child: const Icon(Icons.arrow_forward_ios),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
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
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            musicPlayerProvider
                                    .currentTrack?.album?.images?.first.url ??
                                "",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    musicPlayerProvider.currentTrack?.name ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  Text(
                    flattenArtistName(
                        musicPlayerProvider.currentTrack?.artists),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  const SizedBox(height: 10),
                  musicPlayer(context, musicPlayerProvider),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () => context.push(QueueScreen.routeName),
                          icon: const Icon(
                            CupertinoIcons.list_bullet,
                            color: Colors.white,
                            size: 24,
                          ))
                    ],
                  ),
                  const MiniLyric(),
                  const SizedBox(height: 10),
                  artistCard(context, musicPlayerProvider.currentArtist)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
