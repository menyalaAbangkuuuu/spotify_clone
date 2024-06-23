import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _getUser();
  }

  User? _user;

  User? get user => _user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _getUser() async {
    try {
      _setLoading(true);
      _user = await SpotifyService.getMe();
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login() async {
    await SpotifyService.authenticate();
    _user = await SpotifyService.getMe();
    notifyListeners();
  }
}
