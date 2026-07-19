/// Localized text with en/ru/hi support
class LocalizedText {
  final String? en;
  final String? ru;
  final String? hi;

  const LocalizedText({
    this.en,
    this.ru,
    this.hi,
  });

  factory LocalizedText.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LocalizedText();
    return LocalizedText(
      en: json['en'] as String?,
      ru: json['ru'] as String?,
      hi: json['hi'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (en != null) 'en': en,
      if (ru != null) 'ru': ru,
      if (hi != null) 'hi': hi,
    };
  }

  /// Get text for a specific culture, with fallback chain
  String get(String culture) {
    switch (culture) {
      case 'ru':
        return ru ?? en ?? hi ?? '';
      case 'hi':
        return hi ?? en ?? ru ?? '';
      case 'en':
      default:
        return en ?? ru ?? hi ?? '';
    }
  }

  /// Get text for current UI locale (defaults to 'en')
  String getDefault() => get('en');

  bool get isEmpty => en == null && ru == null && hi == null;
  bool get isNotEmpty => !isEmpty;

  LocalizedText copyWith({
    String? en,
    String? ru,
    String? hi,
  }) {
    return LocalizedText(
      en: en ?? this.en,
      ru: ru ?? this.ru,
      hi: hi ?? this.hi,
    );
  }

  @override
  String toString() => getDefault();
}
