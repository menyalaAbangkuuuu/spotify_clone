import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class PlaylistProvider with ChangeNotifier {
  PlaylistProvider() {
    fetchData();
  }

  List<PlaylistSimple>? _playlists;
  List<PlaylistSimple>? get playlists => _playlists;

  PlaylistSimple? _selectedPlaylist;
  PlaylistSimple? get selectedPlaylist => _selectedPlaylist;

  void fetchData() async {
    _playlists = await SpotifyService.getTopTracks();
    notifyListeners();
  }
}
