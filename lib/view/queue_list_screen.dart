import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';

class QueueListScreen extends StatelessWidget {
  static const routeName = '/queue';
  const QueueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            Provider.of<MusicPlayerProvider>(context).currentTrack?.name ?? ""),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Transform.rotate(
            angle: pi / 2,
            child: const Icon(Icons.arrow_forward_ios),
          ),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Consumer<MusicPlayerProvider>(
        builder: (context, musicPlayerProvider, child) {
          if (musicPlayerProvider.currentTrack == null ||
              musicPlayerProvider.queue.isEmpty) {
            return const Center(child: Text('add song on queue.'));
          }

          return CustomScrollView(
            slivers: [
              SliverStickyHeader(
                header: Container(
                  height: 40.0,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Now Playing',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => ListTile(
                      onTap: () {
                        musicPlayerProvider.setToFirst(i);
                        musicPlayerProvider.play();
                      },
                      title: Text(
                        musicPlayerProvider.currentTrack?.name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Row(
                        children: [
                          musicPlayerProvider.currentTrack?.explicit != null &&
                                  musicPlayerProvider.currentTrack?.explicit ==
                                      true
                              ? Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: const Text(
                                    "E",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const SizedBox(width: 0),
                          SizedBox(
                            width: musicPlayerProvider.currentTrack?.explicit !=
                                        null &&
                                    musicPlayerProvider
                                            .currentTrack?.explicit ==
                                        true
                                ? 5
                                : 0,
                          ),
                          Expanded(
                            child: Text(
                              flattenArtistName(
                                  musicPlayerProvider.currentTrack?.artists),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.6),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      leading: Image.network(musicPlayerProvider
                              .currentTrack?.album!.images?[0].url ??
                          ''),
                    ),
                    childCount: 1,
                  ),
                ),
              ),
              SliverStickyHeader(
                header: Container(
                  height: 40.0,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                sliver: SliverReorderableList(
                  onReorder: (int oldIndex, int newIndex) {
                    musicPlayerProvider.swap(oldIndex, newIndex);
                    HapticFeedback.mediumImpact();
                  },
                  onReorderStart: (_) => HapticFeedback.mediumImpact(),
                  itemCount: musicPlayerProvider.queue.length,
                  itemBuilder: (context, index) {
                    var currentItem = musicPlayerProvider.queue[index];
                    if (musicPlayerProvider.queue.isEmpty) {
                      return const Text("hello");
                    }
                    return Row(
                      key: ValueKey(currentItem.id),
                      children: [
                        Expanded(
                          child: Material(
                            child: ListTile(
                              onTap: () {
                                musicPlayerProvider.setToFirst(index);
                                musicPlayerProvider.play();
                              },
                              title: Text(
                                currentItem.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              subtitle: Row(
                                children: [
                                  currentItem.explicit != null &&
                                          currentItem.explicit == true
                                      ? Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: const Text(
                                            "E",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(width: 0),
                                  SizedBox(
                                    width: currentItem.explicit != null &&
                                            currentItem.explicit == true
                                        ? 5
                                        : 0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      flattenArtistName(currentItem.artists),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              leading: Image.network(
                                  currentItem.album!.images?[0].url ?? ''),
                            ),
                          ),
                        ),
                        ReorderableDragStartListener(
                            index: index,
                            key: ValueKey(currentItem.id),
                            child: const Icon(Icons.reorder)),
                        SizedBox.fromSize(size: const Size(10, 10)),
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
