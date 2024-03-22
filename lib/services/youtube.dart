import 'package:spotify_clone/model/music.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Youtube {
  static final yt = YoutubeExplode();

  static Future<Music> getVideo(
      {required String songName, required String artistName}) async {
    final video = (await yt.search.search("$songName $artistName")).first;
    final videoId = video.id.value;
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final audio = manifest.audio.withHighestBitrate();
    return Music(
      url: audio.url.toString(),
      duration: video.duration,
    );
  }
}
