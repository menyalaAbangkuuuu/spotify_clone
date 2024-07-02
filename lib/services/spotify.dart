import 'dart:convert';
import 'dart:io';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/constants/credentials.dart';
import 'package:spotify_clone/model/playlist_extension.dart';

const _redirectUri = 'myapp://auth/auth';

class SpotifyService {
  static final SpotifyApiCredentials _credentials = SpotifyApiCredentials(
    Credentials.clientId,
    Credentials.clientSecret,
  );
  static SpotifyApi _spotifyApi = SpotifyApi(_credentials);
  static final _grant = SpotifyApi.authorizationCodeGrant(_credentials);
  static final Uri _authUri = _grant.getAuthorizationUrl(
    Uri.parse(_redirectUri),
    scopes: [
      ...AuthorizationScope.user.all,
      AuthorizationScope.library.read,
      ...AuthorizationScope.playlist.all,
    ],
  );

  static Future<bool> isUserAuthenticated() async {
    final sharePrefs = await SharedPreferences.getInstance();
    final token = sharePrefs.getString('accessToken');
    final refreshToken = sharePrefs.getString('refreshToken');
    final expiration = sharePrefs.getString('expiration');

    if (token == null) return false;

    _spotifyApi = SpotifyApi.withAccessToken(token);
    final user = await _spotifyApi.me.get();
    return user.id?.isNotEmpty ?? false;
  }

  static Future<User> getMe() async {
    final me = await _spotifyApi.me.get();
    return me;
  }

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

  void createPlaylist(String playlistName) async {
    final user = await _spotifyApi.me.get();
    await _spotifyApi.playlists.createPlaylist(user.id ?? "", playlistName);
  }

  static Future<List<PlaylistSimple>> getPlaylistFromUser() async {
    final playlists = await _spotifyApi.playlists.me.all();
    return playlists.toList();
  }

  static Future<Playlist> getPlaylistFromSimple(
      PlaylistSimple playlistSimple) async {
    return await _spotifyApi.playlists.get(playlistSimple.id ?? '');
  }

  static Future<PlaylistWithBackground> getPlaylistById(
      String playlistId) async {
    final playlist = await _spotifyApi.playlists.get(playlistId);
    final playlistMusic =
        _spotifyApi.playlists.getTracksByPlaylistId(playlistId);
    final pages = await playlistMusic.all();
    playlist.tracks?.itemsNative =
        pages.toList().where((element) => element.type != "episode").toList();
    final backgroundColor = await playlist.fetchBackgroundColor();

    return PlaylistWithBackground(
        playlist: playlist, backgroundColor: backgroundColor);
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
