import 'localized_text.dart';

class Episode {
  final int id;
  final int seasonId;
  final LocalizedText name;
  final String? image;
  final String? file;
  final int version;
  final String? product;
  final DateTime date;
  final int order;

  const Episode({
    required this.id,
    required this.seasonId,
    required this.name,
    this.image,
    this.file,
    this.version = 1,
    this.product,
    required this.date,
    this.order = 0,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      seasonId: json['seasonId'] as int,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      image: json['image'] as String?,
      file: json['file'] as String?,
      version: json['version'] as int? ?? 1,
      product: json['product'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonId': seasonId,
      'name': name.toJson(),
      'image': image,
      'file': file,
      'version': version,
      'product': product,
      'date': date.toIso8601String().split('T').first,
      'order': order,
    };
  }

  bool get hasFile => file != null && file!.isNotEmpty;

  Episode copyWith({
    int? id,
    int? seasonId,
    LocalizedText? name,
    String? image,
    String? file,
    int? version,
    String? product,
    DateTime? date,
    int? order,
  }) {
    return Episode(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      name: name ?? this.name,
      image: image ?? this.image,
      file: file ?? this.file,
      version: version ?? this.version,
      product: product ?? this.product,
      date: date ?? this.date,
      order: order ?? this.order,
    );
  }
}

class EpisodeInput {
  final int seasonId;
  final LocalizedText name;
  final String? image;
  final String? file;
  final int? version;
  final String? product;
  final DateTime? date;
  final int? order;

  const EpisodeInput({
    required this.seasonId,
    required this.name,
    this.image,
    this.file,
    this.version,
    this.product,
    this.date,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'seasonId': seasonId,
      'name': name.toJson(),
      if (image != null) 'image': image,
      if (file != null) 'file': file,
      if (version != null) 'version': version,
      if (product != null) 'product': product,
      if (date != null) 'date': date!.toIso8601String().split('T').first,
      if (order != null) 'order': order,
    };
  }
}
