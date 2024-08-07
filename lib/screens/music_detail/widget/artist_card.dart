import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/screens/artist/artist_screen.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicPlayerProvider>();
    if (musicProvider.currentTrack == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        context.push(
            '${ArtistScreen.routeName}/${musicProvider.currentTrack!.artists?[0].id}');
      },
      child: Card(
        color: const Color(0xff2F2F2F),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: musicProvider.isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: 200,
                  color: Colors.black.withOpacity(.6),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl:
                              musicProvider.currentArtist?.images?.first.url ??
                                  "",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(.2),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.black.withOpacity(.5),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.black.withOpacity(.6),
                            ),
                          ),
                          errorWidget: (context, url, error) => const SizedBox(
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("About the artist",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  musicProvider.currentArtist?.name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                    "${NumberFormat.compact().format(musicProvider.currentArtist?.followers?.total ?? 0)} followers",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(.6),
                                        )),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
