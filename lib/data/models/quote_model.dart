import 'localized_text.dart';

enum QuoteStatus { published, scheduled }

class Quote {
  final int id;
  final LocalizedText text;
  final LocalizedText image; // image URLs per language
  final DateTime? publishDate;
  final QuoteStatus status;

  const Quote({
    required this.id,
    required this.text,
    required this.image,
    this.publishDate,
    this.status = QuoteStatus.published,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    final publishDateStr = json['publishDate'] as String?;
    final publishDate = publishDateStr != null ? DateTime.tryParse(publishDateStr) : null;

    // Determine status based on publishDate
    QuoteStatus status;
    if (json['status'] != null) {
      status = json['status'] == 'scheduled' ? QuoteStatus.scheduled : QuoteStatus.published;
    } else if (publishDate != null && publishDate.isAfter(DateTime.now())) {
      status = QuoteStatus.scheduled;
    } else {
      status = QuoteStatus.published;
    }

    return Quote(
      id: json['id'] as int,
      text: LocalizedText.fromJson(json['text'] as Map<String, dynamic>?),
      image: LocalizedText.fromJson(json['image'] as Map<String, dynamic>?),
      publishDate: publishDate,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text.toJson(),
      'image': image.toJson(),
      if (publishDate != null) 'publishDate': publishDate!.toIso8601String(),
    };
  }

  bool get isScheduled => status == QuoteStatus.scheduled;
  bool get isPublished => status == QuoteStatus.published;

  Quote copyWith({
    int? id,
    LocalizedText? text,
    LocalizedText? image,
    DateTime? publishDate,
    QuoteStatus? status,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      image: image ?? this.image,
      publishDate: publishDate ?? this.publishDate,
      status: status ?? this.status,
    );
  }
}

class QuoteInput {
  final LocalizedText text;
  final LocalizedText image;
  final DateTime? publishDate;

  const QuoteInput({
    required this.text,
    required this.image,
    this.publishDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text.toJson(),
      'image': image.toJson(),
      if (publishDate != null) 'publishDate': publishDate!.toIso8601String(),
    };
  }
}
