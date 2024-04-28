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
    _categories =
        await SpotifyService.getCategories(offset: _categories?.length ?? 0);
    notifyListeners();
  }

  void selectCategory(Category category) {
    _category = category;
    notifyListeners();
  }

  Future<void> getCategoryDetail(String categoryId) async {
    _category =
        (await SpotifyService.getCategoryDetail(categoryId)) as Category?;
    notifyListeners();
  }

  Future<List<PlaylistSimple>?> getPlaylistsByCategoryId(String categoryId) {
    return SpotifyService.getPlaylistsByCategoryId(categoryId);
  }

  getPlaylistFromSimple(PlaylistSimple playlist) {}
}
