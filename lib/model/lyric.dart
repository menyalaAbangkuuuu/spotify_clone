class Lyric {
  Lyric({
    required this.error,
    required this.syncType,
    required this.lines,
  });
  late final bool error;
  late final String syncType;
  late final List<Lines> lines;

  Lyric.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    syncType = json['syncType'];
    lines = List.from(json['lines']).map((e) => Lines.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['syncType'] = syncType;
    _data['lines'] = lines.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Lines {
  Lines({
    required this.startTimeMs,
    required this.words,
    required this.syllables,
    required this.endTimeMs,
  });
  late final String startTimeMs;
  late final String words;
  late final List<dynamic> syllables;
  late final String endTimeMs;

  Lines.fromJson(Map<String, dynamic> json) {
    startTimeMs = json['startTimeMs'];
    words = json['words'];
    syllables = List.castFrom<dynamic, dynamic>(json['syllables']);
    endTimeMs = json['endTimeMs'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startTimeMs'] = startTimeMs;
    _data['words'] = words;
    _data['syllables'] = syllables;
    _data['endTimeMs'] = endTimeMs;
    return _data;
  }
}
