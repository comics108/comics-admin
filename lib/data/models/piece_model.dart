class Piece {
  final int id;
  final int puzzleId;
  final int x;
  final int y;
  final int width;
  final int height;
  final String? file;
  final int version;
  final DateTime date;
  final int order;

  const Piece({
    required this.id,
    required this.puzzleId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.file,
    this.version = 1,
    required this.date,
    this.order = 0,
  });

  factory Piece.fromJson(Map<String, dynamic> json) {
    return Piece(
      id: json['id'] as int,
      puzzleId: json['puzzleId'] as int,
      x: json['x'] as int? ?? 0,
      y: json['y'] as int? ?? 0,
      width: json['width'] as int? ?? 1,
      height: json['height'] as int? ?? 1,
      file: json['file'] as String?,
      version: json['version'] as int? ?? 1,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puzzleId': puzzleId,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'file': file,
      'version': version,
      'date': date.toIso8601String().split('T').first,
      'order': order,
    };
  }

  String get position => '($x, $y)';
  String get size => '${width}×$height';
  bool get hasFile => file != null && file!.isNotEmpty;

  Piece copyWith({
    int? id,
    int? puzzleId,
    int? x,
    int? y,
    int? width,
    int? height,
    String? file,
    int? version,
    DateTime? date,
    int? order,
  }) {
    return Piece(
      id: id ?? this.id,
      puzzleId: puzzleId ?? this.puzzleId,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      file: file ?? this.file,
      version: version ?? this.version,
      date: date ?? this.date,
      order: order ?? this.order,
    );
  }
}

class PieceInput {
  final int puzzleId;
  final int x;
  final int y;
  final int width;
  final int height;
  final String? file;
  final int? version;
  final DateTime? date;
  final int? order;

  const PieceInput({
    required this.puzzleId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.file,
    this.version,
    this.date,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'puzzleId': puzzleId,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      if (file != null) 'file': file,
      if (version != null) 'version': version,
      if (date != null) 'date': date!.toIso8601String().split('T').first,
      if (order != null) 'order': order,
    };
  }
}
