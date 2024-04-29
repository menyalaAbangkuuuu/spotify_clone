import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class SearchProvider with ChangeNotifier {
  late List<Track> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Track> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> searchSong(String query) async {
    _isLoading = true;
    notifyListeners();
    var jsonResponse = await SpotifyService.searchMusic(query);
    List<Track> trackList = [];
    for (var track in jsonResponse) {
      trackList.add(track as Track);
    }
    _searchResults = trackList;
    _isLoading = false;
    notifyListeners();
  }

  // fetch more
  Future<void> fetchMore(String query, [int offset = 0]) async {
    var jsonResponse = await SpotifyService.searchMusic(query, offset);
    List<Track> trackList = [];
    for (var track in jsonResponse) {
      trackList.add(track as Track);
    }
    _searchResults.addAll(trackList);
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
}
