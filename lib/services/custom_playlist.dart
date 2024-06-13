import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/model/custom_playlist.dart';

abstract class CustomPlaylistServiceBase {
  Future<CustomPlaylist> createCustomPlaylist(String name);

  Future<CustomPlaylist> updateCustomPlaylist(
      String? name, String? description, String? imageUrl);

  Future<List<CustomPlaylist>> getAllCustomPlaylists(String userId);

  Future<void> deleteCustomPlaylist(String id);

  Future<CustomPlaylistWithTracks> getPlaylistDetail(String id);

  Future<void> addSongToCustomPlaylist(String playlistId, String songId);

  Future<void> removeSongFromCustomPlaylist(String playlistId, String songId);

  Future<void> deleteAllSongsFromCustomPlaylist(String playlistId);
}

// TODO: implement semua method yang ada pada CustomPlaylistServiceBase

class CustomPlaylistService implements CustomPlaylistServiceBase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<CustomPlaylist>> getAllCustomPlaylists(String userId) async {
    final querySnapshot = await _db
        .collection('playlists')
        .where('userId', isEqualTo: userId)
        .get();
    if (querySnapshot.docs.length.isNaN) return [];
    return querySnapshot.docs
        .map((doc) => CustomPlaylist.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> addSongToCustomPlaylist(String playlistId, String songId) {
    // TODO: implement addSongToCustomPlaylist
    throw UnimplementedError();
  }

  @override
  Future<CustomPlaylist> createCustomPlaylist(String name) {
    // TODO: implement createCustomPlaylist
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllSongsFromCustomPlaylist(String playlistId) {
    // TODO: implement deleteAllSongsFromCustomPlaylist
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCustomPlaylist(String id) {
    // TODO: implement deleteCustomPlaylist
    throw UnimplementedError();
  }

  @override
  Future<CustomPlaylistWithTracks> getPlaylistDetail(String id) {
    // TODO: implement getPlaylistDetail
    throw UnimplementedError();
  }

  @override
  Future<void> removeSongFromCustomPlaylist(String playlistId, String songId) {
    // TODO: implement removeSongFromCustomPlaylist
    throw UnimplementedError();
  }

  @override
  Future<CustomPlaylist> updateCustomPlaylist(
      String? name, String? description, String? imageUrl) {
    // TODO: implement updateCustomPlaylist
    throw UnimplementedError();
  }
}
