import 'package:flutter/material.dart' hide Page, Image;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/constants/credentials.dart';
import 'package:spotify_clone/model/artist_detail.dart';
import 'package:spotify_clone/model/playlist_extension.dart';

const _redirectUri = 'myapp://auth/auth';

class SpotifyService {
  static final SpotifyApiCredentials _credentials = SpotifyApiCredentials(
    Credentials.clientId,
    Credentials.clientSecret,
  );

  // TODO nanti ini dibuat dokumentasinya ya

  static SpotifyApi _spotifyApi =
      SpotifyApi(_credentials, onCredentialsRefreshed: (cred) async {
    final sharePrefs = await SharedPreferences.getInstance();
    await sharePrefs.setString('accessToken', cred.accessToken ?? "");
    await sharePrefs.setString('refreshToken', cred.refreshToken ?? "");
    await sharePrefs.setString('scopes', cred.scopes?.join(",") ?? "");
    await sharePrefs.setString('expiration', cred.expiration.toString());
  });
  static final _grant = SpotifyApi.authorizationCodeGrant(_credentials);
  static final Uri _authUri = _grant.getAuthorizationUrl(
    Uri.parse(_redirectUri),
    scopes: [
      ...AuthorizationScope.user.all,
      ...AuthorizationScope.library.all,
      ...AuthorizationScope.playlist.all,
    ],
  );

  // TODO nanti ini dibuat dokumentasinya ya

  static Future<bool> isUserAuthenticated() async {
    final sharePrefs = await SharedPreferences.getInstance();
    final token = sharePrefs.getString('accessToken');
    final expiration = sharePrefs.getString('expiration');

    if (token == null ||
        expiration != null &&
            DateTime.parse(expiration).isBefore(DateTime.now())) {
      return false;
    }

    _spotifyApi = SpotifyApi.withAccessToken(token);
    final user = await _spotifyApi.me.get();
    return user.id?.isNotEmpty ?? false;
  }

  static Future<User> getMe() async {
    final me = await _spotifyApi.me.get();
    return me;
  }

  // TODO nanti ini dibuat dokumentasinya ya

  static Future<void> authenticate() async {
    try {
      final res = await FlutterWebAuth2.authenticate(
        url: _authUri.toString(),
        options: const FlutterWebAuth2Options(
          intentFlags: ephemeralIntentFlags,
        ),
        callbackUrlScheme: "myapp",
      );

      _spotifyApi = SpotifyApi.fromAuthCodeGrant(_grant, res.toString());
      final credential = await _spotifyApi.getCredentials();

      final sharePrefs = await SharedPreferences.getInstance();
      await sharePrefs.setString('accessToken', credential.accessToken ?? "");
      await sharePrefs.setString('refreshToken', credential.refreshToken ?? "");
      await sharePrefs.setString('scopes', credential.scopes?.join(",") ?? "");
      await sharePrefs.setString(
          'expiration', credential.expiration.toString());
    } catch (e) {
      print(e);
      throw Exception("Failed to launch");
    }
  }

  // TODO nanti ini dibuat dokumentasinya ya

  static Future<void> logOut() async {
    final sharePrefs = await SharedPreferences.getInstance();
    await sharePrefs.remove('accessToken');
    await sharePrefs.remove('refreshToken');
    await sharePrefs.remove('scopes');
    await sharePrefs.remove('expiration');
    _spotifyApi = SpotifyApi(_credentials);
  }

  static Future<List<PlaylistSimple>?> getTopTracks() async {
    final response = await _spotifyApi.playlists.featured.getPage(10);
    return response.items?.toList();
  }

  static Future<Track> getTrack(String trackId) async {
    final track = await _spotifyApi.tracks.get(trackId);
    return track;
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

  static Future<List<PlaylistSimple>> getPlaylistFromUser() async {
    final playlists = await _spotifyApi.playlists.me.all();
    final PlaylistSimple likedSong = PlaylistSimple()
      ..name = "Liked Songs"
      ..id = "liked-songs"
      ..description = "Your liked songs"
      ..images = [
        Image()
          ..url =
              "https://i1.sndcdn.com/artworks-y6qitUuZoS6y8LQo-5s2pPA-t500x500.jpg"
      ];
    return [likedSong, ...playlists];
  }

  static Future<List<TrackSaved>> getUserSavedTracks() async {
    final response = await _spotifyApi.tracks.me.saved.all();
    return response.toList();
  }

  static Future<void> addSongToSavedTracks(String trackId) async {
    await _spotifyApi.tracks.me.saveOne(trackId);
  }

  static Future<Playlist> getPlaylistFromSimple(
      PlaylistSimple playlistSimple) async {
    return await _spotifyApi.playlists.get(playlistSimple.id ?? '');
  }

  static Future<PlaylistWithBackground> getPlaylistById(
      String playlistId) async {
    final playlistFuture = _spotifyApi.playlists.get(playlistId);
    final playlistMusicFuture = getMusicByPlaylist(playlistId);

    final results = await Future.wait([playlistFuture, playlistMusicFuture]);

    final playlist = results[0] as Playlist;
    final playlistMusic = results[1] as List<Track>;

    playlist.tracks?.itemsNative = playlistMusic;

    final backgroundColor = playlist.images?.first.url == null
        ? Colors.black
        : await playlist.fetchBackgroundColor();

    return PlaylistWithBackground(
        playlist: playlist, backgroundColor: backgroundColor);
  }

  static Future<List<Track>> getMusicByPlaylist(String playlistId) async {
    final playlist = _spotifyApi.playlists.getTracksByPlaylistId(playlistId);
    final pages = await playlist.getPage(50);
    return pages.items
            ?.toList()
            .where((element) => element.type != "episode")
            .toList() ??
        [];
  }

  static Future<Artist> getArtist(String artistId) async {
    final artist = await _spotifyApi.artists.get(artistId);
    return artist;
  }

  // TODO nanti ini dibuat dokumentasinya ya

  static Future<bool> checkTrackSaved(String trackId) async {
    final response = await _spotifyApi.tracks.me.containsOne(trackId);
    return response;
  }

  // TODO nanti ini dibuat dokumentasinya ya

  static Future<ArtistDetail> getArtistData(String artistId) async {
    final artistFuture = _spotifyApi.artists.get(artistId);
    final topTracksFuture = _spotifyApi.artists.topTracks(artistId, Market.ID);
    final albumsPageFuture = _spotifyApi.artists.albums(artistId);
    final albums = albumsPageFuture.getPage(10);

    // Run all the futures in parallel and wait for all of them to complete
    final results = await Future.wait([artistFuture, topTracksFuture, albums]);

    // Extract results
    final artist = results[0] as Artist;
    final topTracks = (results[1] as Iterable<Track>).toList();
    final album = (results[2] as Page<Album>).items?.toList() ?? [];

    return ArtistDetail(artist: artist, albums: album, topTracks: topTracks);
  }

  // TODO nanti ini dibuat dokumentasinya ya

  static Future<void> createPlaylist(String playlistName) async {
    final user = await _spotifyApi.me.get();
    await _spotifyApi.playlists.createPlaylist(user.id ?? "", playlistName);
  }

  // TODO nanti ini dibuat dokumentasinya ya
  static Future<void> addSongToPlaylist(
      String playlistName, String trackId) async {
    await _spotifyApi.playlists.addTrack(trackId, playlistName);
  }
}
