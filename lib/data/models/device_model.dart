class Device {
  final int id;
  final int platform;
  final String platformName;
  final String culture;
  final DateTime? lastModified;
  final String? pushToken;
  final String? appVersion;
  final String? model;

  Device({
    required this.id,
    required this.platform,
    required this.platformName,
    this.culture = '',
    this.lastModified,
    this.pushToken,
    this.appVersion,
    this.model,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      platform: json['platform'] as int? ?? 0,
      platformName: json['platformName'] as String? ?? 'unknown',
      culture: json['culture'] as String? ?? '',
      lastModified: json['lastModified'] != null
          ? DateTime.tryParse(json['lastModified'] as String)
          : null,
      pushToken: json['pushToken'] as String?,
      appVersion: json['appVersion'] as String?,
      model: json['model'] as String?,
    );
  }
}

class DeviceStats {
  final int total;
  final int active30days;
  final Map<String, int> byPlatform;

  DeviceStats({
    required this.total,
    required this.active30days,
    required this.byPlatform,
  });

  factory DeviceStats.fromJson(Map<String, dynamic> json) {
    final byPlatformJson = json['byPlatform'] as Map<String, dynamic>? ?? {};
    return DeviceStats(
      total: json['total'] as int? ?? 0,
      active30days: json['active30days'] as int? ?? 0,
      byPlatform: byPlatformJson.map((k, v) => MapEntry(k, v as int? ?? 0)),
    );
  }
}

class ImportResult {
  final int chapters;
  final int slokas;
  final int vocabularies;
  final List<String> warnings;

  ImportResult({
    required this.chapters,
    required this.slokas,
    required this.vocabularies,
    required this.warnings,
  });

  factory ImportResult.fromJson(Map<String, dynamic> json) {
    return ImportResult(
      chapters: json['chapters'] as int? ?? 0,
      slokas: json['slokas'] as int? ?? 0,
      vocabularies: json['vocabularies'] as int? ?? 0,
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
