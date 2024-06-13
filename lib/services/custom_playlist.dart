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
  @override
  Future<CustomPlaylist> createCustomPlaylist(String name) {}
}
