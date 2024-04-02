import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:spotify_clone/model/lyric.dart';

class LyricService {
  static Future<Lyric?> getLyric(String trackId) async {
    final response = await http
        .get(Uri.parse('http://192.168.100.143:8000/?trackid=$trackId'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return Lyric.fromJson(jsonData);
    }
    return null;
  }
}
