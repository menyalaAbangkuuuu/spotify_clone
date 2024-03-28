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

  void getCategoryDetail(String categoryId) async {
    final category = await SpotifyService.getCategoryDetail(categoryId);
    _category = category;
    notifyListeners();
  }
}
