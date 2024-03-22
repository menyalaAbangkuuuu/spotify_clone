import 'package:spotify/spotify.dart';
import 'package:spotify_clone/constants/credentials.dart';

final _spotifyApi = SpotifyApi(
    SpotifyApiCredentials(Credentials.clientId, Credentials.clientSecret));

class SpotifyService {
  static Future<List<PlaylistSimple>?> getTopTracks() async {
    final response = await _spotifyApi.playlists.featured.getPage(10);
    return response.items?.toList();
  }

  static Future<List<dynamic>> searchMusic(String query) async {
    final response = _spotifyApi.search.get(query, types: {SearchType.track});

    var pages = await response.getPage(10);
    return pages[0].items?.toList() ?? [];
  }
}
