import 'package:spotify/spotify.dart';

class ArtistDetail {
  final Artist artist;
  final List<AlbumSimple> albums;
  final List<Track> topTracks;

  ArtistDetail({
    required this.artist,
    required this.albums,
    required this.topTracks,
  });
}
