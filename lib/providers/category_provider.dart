import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class CategoryProvider with ChangeNotifier {
  CategoryProvider() {
    fetchData();
  }

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  void fetchData() async {
    final data = await SpotifyService.getCategories() ?? [];
    data.removeAt(0);
    _categories = data;
    notifyListeners();
  }

  void fetchMore({int offset = 0}) async {
    final data = await SpotifyService.getCategories(offset: offset);

    if (data!.isEmpty) {
      _canLoadMore = false;
      notifyListeners();
      return;
    }

    _categories.addAll(data);
    notifyListeners();
  }

  getPlaylistFromSimple(PlaylistSimple playlist) {}
}
