import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotify_clone/constants/credentials.dart';
import 'package:spotify_clone/model/lyric.dart';

class LyricService {
  static Future<Lyric?> getLyric(String trackId) async {
    final response = await http.get(
        Uri.parse(
            'https://spotify-lyric-server.vercel.app/api/lyric?trackId=$trackId&token=${Credentials.token}'),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.0.0 Safari/537.36',
          "App-platform": "WebPlayer"
        });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return Lyric.fromJson(jsonData['data']);
    } else {
      print(response.body);
    }
    return null;
  }
}
