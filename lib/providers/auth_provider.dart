import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  User? _user;
  User? get currentUser => _user;

  void login(Uri uri) async {
    final user = await SpotifyService.handleSpotifyRedirect(uri);
    print(user?.email);
    if (user != null) {
      _user = user;
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
