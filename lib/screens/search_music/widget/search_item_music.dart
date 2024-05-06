import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/providers/music_player_provider.dart';
import 'package:spotify_clone/screens/search_music/widget/slider_item_music.dart';
import 'package:spotify_clone/utils/flatten_artists_name.dart';

Row searchItemMusic(BuildContext context,
    {required Track track,
    bool isFromPlaylist = false,
    List<Track> tracks = const [],
    int currentIndex = 0}) {
  return Row(
    children: [
      Text(
        (currentIndex + 1).toString(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(
        width: 3,
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Slidable(
            key: const ValueKey(0),
            closeOnScroll: true,
            groupTag: 1,
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.2,
              children: [
                SliderItemMusic(
                  track: track,
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                isFromPlaylist
                    ? Provider.of<MusicPlayerProvider>(context, listen: false)
                        .addFromPlaylist(tracks, currentIndex)
                    : Provider.of<MusicPlayerProvider>(context, listen: false)
                        .addToQueue(track);
                Provider.of<MusicPlayerProvider>(context, listen: false).play();
              },
              title: Text(
                track.name ?? "",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Row(children: [
                track.explicit != null && track.explicit == true
                    ? Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: const Text(
                          "E",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                SizedBox(
                  width:
                      track.explicit != null && track.explicit == true ? 5 : 0,
                ),
                Expanded(
                  child: Text(
                    flattenArtistName(track.artists),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ),
              ]),
              leading: CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: track.album?.images?.first.url ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.black.withOpacity(.5),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.black.withOpacity(.6),
                    height: 50.0,
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
