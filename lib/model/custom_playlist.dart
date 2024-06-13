import 'package:spotify/spotify.dart';
import 'package:spotify_clone/services/spotify.dart';

class CustomPlaylist {
  final String name;
  final String description;
  final String? imageUrl;
  final List<String> songs;

  CustomPlaylist({
    required this.name,
    required this.description,
    this.imageUrl,
    required this.songs,
  });

  factory CustomPlaylist.fromJson(Map<String, dynamic> json) => CustomPlaylist(
        name: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        songs: List<String>.from(json["songs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image": imageUrl,
        "songs": List<String>.from(songs.map((x) => x)),
      };
}

class CustomPlaylistWithTracks extends CustomPlaylist {
  final List<Track> _fetchedTracks = [];

  CustomPlaylistWithTracks(
      {required super.name, required super.description, required super.songs});

  List<Track> get tracks => _fetchedTracks;

  Future<void> fetchTracks() async {
    for (String songId in super.songs) {
      Track track = await SpotifyService.getTrack(songId);
      _fetchedTracks.add(track);
    }
  }
}
