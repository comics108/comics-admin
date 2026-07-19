import 'localized_text.dart';

class Puzzle {
  final int id;
  final int episodeId;
  final LocalizedText name;
  final int rows;
  final int columns;
  final String? image;
  final int version;
  final DateTime date;
  final int order;
  final int piecesCount;

  const Puzzle({
    required this.id,
    required this.episodeId,
    required this.name,
    required this.rows,
    required this.columns,
    this.image,
    this.version = 1,
    required this.date,
    this.order = 0,
    this.piecesCount = 0,
  });

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      id: json['id'] as int,
      episodeId: json['episodeId'] as int? ?? 0,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      rows: json['rows'] as int? ?? json['height'] as int? ?? 3,
      columns: json['columns'] as int? ?? json['width'] as int? ?? 3,
      image: json['image'] as String?,
      version: json['version'] as int? ?? 1,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      order: json['order'] as int? ?? 0,
      piecesCount: json['piecesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episodeId': episodeId,
      'name': name.toJson(),
      'rows': rows,
      'columns': columns,
      'image': image,
      'version': version,
      'date': date.toIso8601String().split('T').first,
      'order': order,
    };
  }

  String get gridSize => '$rows×$columns';
  bool get hasImage => image != null && image!.isNotEmpty;

  Puzzle copyWith({
    int? id,
    int? episodeId,
    LocalizedText? name,
    int? rows,
    int? columns,
    String? image,
    int? version,
    DateTime? date,
    int? order,
    int? piecesCount,
  }) {
    return Puzzle(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      name: name ?? this.name,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      image: image ?? this.image,
      version: version ?? this.version,
      date: date ?? this.date,
      order: order ?? this.order,
      piecesCount: piecesCount ?? this.piecesCount,
    );
  }
}

class PuzzleInput {
  final int episodeId;
  final LocalizedText name;
  final int rows;
  final int columns;
  final String? image;
  final int? version;
  final DateTime? date;
  final int? order;

  const PuzzleInput({
    required this.episodeId,
    required this.name,
    required this.rows,
    required this.columns,
    this.image,
    this.version,
    this.date,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'episodeId': episodeId,
      'name': name.toJson(),
      'rows': rows,
      'columns': columns,
      if (image != null) 'image': image,
      if (version != null) 'version': version,
      if (date != null) 'date': date!.toIso8601String().split('T').first,
      if (order != null) 'order': order,
    };
  }
}
