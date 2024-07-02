import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

class RecentPlayedProvider extends ChangeNotifier {
  final List<Track> _recentPlayed = [];

  List<Track> get recentPlayed => _recentPlayed;

  void addRecentPlayed(Track track) {
    if (_recentPlayed.contains(track)) {
      _recentPlayed.remove(track);
    }
    _recentPlayed.insert(0, track);
    if (_recentPlayed.length > 10) {
      _recentPlayed.removeLast();
    }
    notifyListeners();
  }
}
