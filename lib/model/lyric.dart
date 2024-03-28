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
    final data = <String, dynamic>{};
    data['error'] = error;
    data['syncType'] = syncType;
    data['lines'] = lines.map((e) => e.toJson()).toList();
    return data;
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
    final data = <String, dynamic>{};
    data['startTimeMs'] = startTimeMs;
    data['words'] = words;
    data['syllables'] = syllables;
    data['endTimeMs'] = endTimeMs;
    return data;
  }
}
