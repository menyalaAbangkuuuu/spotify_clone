import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

//TODO : buat provider untuk custom playlist
//di provider ini nanti bisa CRUD custom playlist kita
// dan nnti mau ditampilkan di library
// untuk semua fetching data itu dari https://yourdocumentationlink.com/path-to-provider-docs

class CustomPlaylistProvider extends ChangeNotifier {
  CustomPlaylistProvider() {
    _getUser();
  }

  User? _user;

  void _getUser() {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  // TODO : buat fungsi untuk mengambil playlist user dari firebase
  Future<void> getPlaylist() async {}

  // TODO: buat fungsi untuk menambahkan playlist user ke firebase
  Future<void> addPlaylist() async {}

  // TODO: buat fungsi untuk menghapus playlist user ke firebase
  Future<void> removePlaylist() async {}

  // TODO: buat fungsi untuk mengambil playlist detail ke firebase
  Future<void> getPlaylistDetail(String id) async {}
}
