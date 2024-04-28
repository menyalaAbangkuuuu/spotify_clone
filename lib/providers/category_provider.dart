import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class CategoryProvider with ChangeNotifier {
  CategoryProvider() {
    fetchData();
  }

  List<Category>? _categories;

  List<Category>? get categories => _categories;

  Category? _category;

  Category? get category => _category;

  void fetchData() async {
    _categories = await SpotifyService.getCategories();
    notifyListeners();
  }

  void fetchMore({int offset = 0}) async {
    final data = await SpotifyService.getCategories(offset: offset);
    if (_category != null) {
      _categories!.addAll(data!);
    }
    notifyListeners();
  }

  // Future<void> getPlaylistsByCategoryId(String categoryId) {
  //   return SpotifyService.getPlaylistsByCategoryId(categoryId);
  // }

  getPlaylistFromSimple(PlaylistSimple playlist) {}
}
