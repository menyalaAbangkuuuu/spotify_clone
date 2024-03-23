import 'package:spotify/spotify.dart';

String flattenArtistName(List<Artist>? artists) {
  return artists!.isNotEmpty
      ? artists.map((artist) => artist.name).join(', ')
      : "";
}
