import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:spotify_clone/model/lyric.dart';

class LyricService {
  static Future<Lyric?> getLyric(String trackId) async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/?trackid=$trackId'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return Lyric.fromJson(jsonData);
    }
    return null;
  }
}
