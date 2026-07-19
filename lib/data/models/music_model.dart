import 'localized_text.dart';

class Music {
  final int id;
  final LocalizedText name;
  final LocalizedText author;
  final String? file;
  final int order;

  const Music({
    required this.id,
    required this.name,
    required this.author,
    this.file,
    this.order = 0,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] as int,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      author: LocalizedText.fromJson(json['author'] as Map<String, dynamic>?),
      file: json['file'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'author': author.toJson(),
      'file': file,
      'order': order,
    };
  }

  bool get hasFile => file != null && file!.isNotEmpty;

  Music copyWith({
    int? id,
    LocalizedText? name,
    LocalizedText? author,
    String? file,
    int? order,
  }) {
    return Music(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      file: file ?? this.file,
      order: order ?? this.order,
    );
  }
}

class MusicInput {
  final LocalizedText name;
  final LocalizedText author;
  final String? file;
  final int? order;

  const MusicInput({
    required this.name,
    required this.author,
    this.file,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'author': author.toJson(),
      if (file != null) 'file': file,
      if (order != null) 'order': order,
    };
  }
}
