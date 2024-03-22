import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class MusicProvider extends ChangeNotifier {
  List<PlaylistSimple>? topTracks;

  MusicProvider() {
    getTopPLaylist();
  }

  Future<void> getTopPLaylist() async {
    topTracks = await SpotifyService.getTopTracks();
    notifyListeners();
  }
}
