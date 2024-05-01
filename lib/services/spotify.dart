import 'package:spotify/spotify.dart';
import 'package:spotify_clone/constants/credentials.dart';

final _spotifyApi = SpotifyApi(
    SpotifyApiCredentials(Credentials.clientId, Credentials.clientSecret));

class SpotifyService {
  static Future<List<PlaylistSimple>?> getTopTracks() async {
    final response = await _spotifyApi.playlists.featured.getPage(10);
    return response.items?.toList();
  }

  static Future<List<dynamic>> searchMusic(String query,
      [int offset = 0]) async {
    final response = _spotifyApi.search.get(query, types: {SearchType.track});

    var pages = await response.getPage(10, offset);
    return pages[0].items?.toList() ?? [];
  }

  static Future<List<Category>?> getCategories({int offset = 0}) async {
    final response =
        _spotifyApi.categories.list(country: Market.ID, locale: "id-ID");
    var pages = await response.getPage(9, offset);
    return pages.items?.toList() as List<Category>;
  }

  static Future<List<PlaylistSimple>?> getCategoryDetail(
      String categoryId) async {
    final res = _spotifyApi.playlists.getByCategoryId(categoryId);
    final pages = await res.getPage(10);
    return pages.items?.toList();
  }

  static Future<List<Track>?> getPlaylistDetail(String playlistId) async {
    final playlist = _spotifyApi.playlists.getTracksByPlaylistId(playlistId);
    final pages = await playlist.getPage(10);
    return pages.items?.toList();
  }

  static Future<List<PlaylistSimple>?> getFeaturedPlaylists() async {
    final response = await _spotifyApi.playlists.featured.getPage(10);
    return response.items?.toList();
  }

  static Future<List<PlaylistSimple>?> getCategoryPlaylists(
      String categoryId) async {
    final response = _spotifyApi.playlists.getByCategoryId(categoryId);
    return response.getPage(10).then((value) => value.items?.toList());
  }

  static Future<List<PlaylistSimple>?> getPlaylistsByCategoryId(
      String categoryId) async {
    final response = _spotifyApi.playlists.getByCategoryId(categoryId);
    final pages = await response.getPage(10);
    return pages.items?.toList();
  }

  static Future<Playlist> getPlaylistFromSimple(
      PlaylistSimple playlistSimple) async {
    return await _spotifyApi.playlists.get(playlistSimple.id ?? '');
  }

  static Future<Playlist> getPlaylistById(String playlistId) async {
    final playlist = await _spotifyApi.playlists.get(playlistId);
    final playlistMusic =
        _spotifyApi.playlists.getTracksByPlaylistId(playlistId);
    final pages = await playlistMusic.getPage(50);
    playlist.tracks?.itemsNative = pages.items;
    return playlist;
  }

  static Future<List<Track>?> getMusicByPlaylist(String playlistId) async {
    final playlist = _spotifyApi.playlists.getTracksByPlaylistId(playlistId);
    final pages = await playlist.getPage(50);
    return pages.items?.toList();
  }

  static Future<Artist> getArtist(String artistId) async {
    final artist = await _spotifyApi.artists.get(artistId);
    return artist;
  }
}
