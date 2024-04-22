class Lyric {
  Lyric({
    required this.lyrics,
    required this.colors,
    required this.hasVocalRemoval,
  });
  late final Lyrics lyrics;
  late final LyricColor colors;
  late final bool hasVocalRemoval;

  Lyric.fromJson(Map<String, dynamic> json) {
    lyrics = Lyrics.fromJson(json['lyrics']);
    colors = LyricColor.fromJson(json['colors']);
    hasVocalRemoval = json['hasVocalRemoval'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lyrics'] = lyrics.toJson();
    _data['colors'] = colors.toJson();
    _data['hasVocalRemoval'] = hasVocalRemoval;
    return _data;
  }
}

class Lyrics {
  Lyrics({
    required this.syncType,
    required this.lines,
    required this.provider,
    required this.providerLyricsId,
    required this.providerDisplayName,
    required this.syncLyricsUri,
    required this.isDenseTypeface,
    required this.alternatives,
    required this.language,
    required this.isRtlLanguage,
    required this.fullscreenAction,
    required this.showUpsell,
    required this.capStatus,
    required this.impressionsRemaining,
  });
  late final String syncType;
  late final List<Lines> lines;
  late final String provider;
  late final String providerLyricsId;
  late final String providerDisplayName;
  late final String syncLyricsUri;
  late final bool isDenseTypeface;
  late final List<dynamic> alternatives;
  late final String language;
  late final bool isRtlLanguage;
  late final String fullscreenAction;
  late final bool showUpsell;
  late final String capStatus;
  late final int impressionsRemaining;

  Lyrics.fromJson(Map<String, dynamic> json) {
    syncType = json['syncType'] ?? '';
    lines = List.from(json['lines']).map((e) => Lines.fromJson(e)).toList();
    provider = json['provider'];
    providerLyricsId = json['providerLyricsId'];
    providerDisplayName = json['providerDisplayName'];
    syncLyricsUri = json['syncLyricsUri'];
    isDenseTypeface = json['isDenseTypeface'];
    alternatives = List.castFrom<dynamic, dynamic>(json['alternatives']);
    language = json['language'];
    isRtlLanguage = json['isRtlLanguage'];
    fullscreenAction = json['fullscreenAction'];
    showUpsell = json['showUpsell'];
    capStatus = json['capStatus'];
    impressionsRemaining = json['impressionsRemaining'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['syncType'] = syncType;
    data['lines'] = lines.map((e) => e.toJson()).toList();
    data['provider'] = provider;
    data['providerLyricsId'] = providerLyricsId;
    data['providerDisplayName'] = providerDisplayName;
    data['syncLyricsUri'] = syncLyricsUri;
    data['isDenseTypeface'] = isDenseTypeface;
    data['alternatives'] = alternatives;
    data['language'] = language;
    data['isRtlLanguage'] = isRtlLanguage;
    data['fullscreenAction'] = fullscreenAction;
    data['showUpsell'] = showUpsell;
    data['capStatus'] = capStatus;
    data['impressionsRemaining'] = impressionsRemaining;
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
  late final int startTimeMs;
  late final String words;
  late final List<dynamic> syllables;
  late final int endTimeMs;

  Lines.fromJson(Map<String, dynamic> json) {
    startTimeMs = json['startTimeMs'] ?? 0;
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

class LyricColor {
  LyricColor({
    required this.background,
    required this.highlightText,
    required this.text,
  });
  late final String background;
  late final String highlightText;
  late final String text;

  LyricColor.fromJson(Map<String, dynamic> json) {
    background = json['background'];
    highlightText = json['highlightText'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['background'] = background;
    data['highlightText'] = highlightText;
    data['text'] = text;
    return data;
  }
}
