import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';
import 'package:spotify_clone/screens/music_detail/music_detail_screen.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (context, musicPlayerProvider, child) {
        if (musicPlayerProvider.errorMessage.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(musicPlayerProvider.errorMessage),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.red[300],
              ),
            );
            musicPlayerProvider.clearError();
          });
        }
        if (musicPlayerProvider.currentTrack == null) {
          return const SizedBox.shrink();
        }
        _controller.forward();
        return FadeTransition(
          opacity: _opacityAnimation,
          child: GestureDetector(
            onTap: () => context.push(MusicDetailScreen.routeName),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                        // Display the album cover image or a default icon
                        CachedNetworkImage(
                          imageUrl: musicPlayerProvider
                                  .currentTrack?.album?.images?.first.url ??
                              '',
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 40,
                          height: 40,
                        ),
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
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                flattenArtistName(
                                    musicPlayerProvider.currentTrack?.artists),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
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
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<Duration>(
                    stream: musicPlayerProvider.audioPlayer.onPositionChanged,
                    builder: (context, snapshot) {
                      return ProgressBar(
                        progress: snapshot.data ?? Duration.zero,
                        total: musicPlayerProvider.totalDuration,
                        timeLabelLocation: TimeLabelLocation.none,
                        bufferedBarColor: Colors.white38,
                        barHeight: 2,
                        baseBarColor: Colors.white10,
                        thumbColor: Colors.transparent,
                        progressBarColor: Colors.white,
                        onSeek: (duration) =>
                            musicPlayerProvider.seek(duration),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
