import 'localized_text.dart';

class Season {
  final int id;
  final LocalizedText name;
  final String? image;
  final String? product;
  final int order;
  final int episodesCount;

  const Season({
    required this.id,
    required this.name,
    this.image,
    this.product,
    this.order = 0,
    this.episodesCount = 0,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] as int,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      image: json['image'] as String?,
      product: json['product'] as String?,
      order: json['order'] as int? ?? 0,
      episodesCount: json['episodesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'image': image,
      'product': product,
      'order': order,
    };
  }

  bool get hasImage => image != null && image!.isNotEmpty;

  Season copyWith({
    int? id,
    LocalizedText? name,
    String? image,
    String? product,
    int? order,
    int? episodesCount,
  }) {
    return Season(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      product: product ?? this.product,
      order: order ?? this.order,
      episodesCount: episodesCount ?? this.episodesCount,
    );
  }
}

class SeasonInput {
  final LocalizedText name;
  final String? image;
  final String? product;
  final int? order;

  const SeasonInput({
    required this.name,
    this.image,
    this.product,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      if (image != null) 'image': image,
      if (product != null) 'product': product,
      if (order != null) 'order': order,
    };
  }
}
