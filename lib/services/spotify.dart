import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/constants/credentials.dart';
import 'package:spotify_clone/utils/code_challenge.dart';
import 'package:url_launcher/url_launcher.dart';

final _scopes = [
  AuthorizationScope.playlist.modifyPrivate,
  AuthorizationScope.playlist.modifyPublic,
  AuthorizationScope.library.read,
  AuthorizationScope.library.modify,
  AuthorizationScope.connect.readPlaybackState,
  AuthorizationScope.connect.modifyPlaybackState,
  AuthorizationScope.listen.readRecentlyPlayed,
  AuthorizationScope.follow.read
];

final _spotifyApi = SpotifyApi(
    SpotifyApiCredentials(Credentials.clientId, Credentials.clientSecret));

final CodeData generatePKCECodes = CodeChallenge.generatePKCECodes(64);

final _grant = SpotifyApi.authorizationCodeGrant(
  SpotifyApiCredentials(Credentials.clientId, Credentials.clientSecret),
);

final _authUri = _grant.getAuthorizationUrl(
    Uri.parse('spotify-ios-quick-start://spotify-login-callback'),
    scopes: _scopes);

class SpotifyService {
  static Future<SpotifyApiCredentials> getCredentials() async {
    return await _spotifyApi.getCredentials();
  }

  static Future login() async {
    await const FlutterSecureStorage()
        .write(key: "codeVerifier", value: generatePKCECodes.codeVerifier);

    if (await canLaunchUrl(_authUri)) {
      await launchUrl(_authUri);

      // final client =
      //     await grant.handleAuthorizationResponse(redirectUri.queryParameters);
    } else {
      throw 'Could not launch $_authUri';
    }

    // return SpotifyApi.fromClient(client);
  }

  static Future<List<PlaylistSimple>?> getTopTracks() async {
    final response = await _spotifyApi.playlists.featured.getPage(10);
    return response.items?.toList();
  }

  static Future<List<dynamic>> searchMusic(String query) async {
    final response = _spotifyApi.search.get(query, types: {SearchType.track});

    var pages = await response.getPage(10);
    return pages[0].items?.toList() ?? [];
  }

  static Future<List<Category>?> getCategories({int offset = 0}) async {
    final response =
        _spotifyApi.categories.list(country: Market.ID, locale: "id-ID");
    var pages = await response.getPage(10, offset);
    return pages.items?.toList() as List<Category>;
  }

  static Future<Category> getCategoryDetail(String categoryId) async {
    final data = _spotifyApi.categories.get(categoryId);

    return data;
  }

  static Future<User?> handleSpotifyRedirect(Uri uri) async {
    try {
      final client =
          await _grant.handleAuthorizationResponse(uri.queryParameters);

      final spotifyApi = SpotifyApi.fromClient(client);
      print(await spotifyApi.me.get());
      return await spotifyApi.me.get();
    } catch (e) {
      print(e);
    }
    return null;
  }
}
