import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_clone/model/custom_playlist.dart';
import 'package:spotify_clone/services/custom_playlist.dart';

//TODO : buat provider untuk custom playlist
//di provider ini nanti bisa CRUD custom playlist kita
// dan nnti mau ditampilkan di library
// untuk semua fetching data itu dari https://yourdocumentationlink.com/path-to-provider-docs

class CustomPlaylistProvider extends ChangeNotifier {
  final _customPlaylistService = CustomPlaylistService();

  CustomPlaylistProvider() {
    _getUser();
    getAllPlaylist();
  }

  User? _user;

  void _getUser() {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  final List<CustomPlaylist> _customPlaylists = [];

  List<CustomPlaylist> get customPlaylists => _customPlaylists;

  Future<void> getAllPlaylist() async {
    List<CustomPlaylist> playlist =
        await _customPlaylistService.getAllCustomPlaylists(_user?.uid ?? '');
    _customPlaylists.addAll(playlist);
    notifyListeners();
  }

  // TODO: buat fungsi untuk menambahkan playlist user ke firebase
  Future<void> addPlaylist() async {}

  // TODO: buat fungsi untuk menghapus playlist user ke firebase
  Future<void> removePlaylist() async {}

  // TODO: buat fungsi untuk mengambil playlist detail ke firebase
  Future<void> getPlaylistDetail(String id) async {}
}
