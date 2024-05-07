import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class SearchProvider extends ChangeNotifier {
  late List<Track> _searchResults = [];
  List<Track> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

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
    if (jsonResponse.isEmpty) {
      _canLoadMore = false;
      notifyListeners();
      return;
    }
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
