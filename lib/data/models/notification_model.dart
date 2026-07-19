import 'localized_text.dart';

class NotificationInput {
  final LocalizedText title;
  final LocalizedText body;
  final String platform; // 'all', 'ios', 'android'

  const NotificationInput({
    required this.title,
    required this.body,
    this.platform = 'all',
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title.toJson(),
      'body': body.toJson(),
      'platform': platform,
    };
  }
}

class NotificationResult {
  final int sent;
  final int failed;

  const NotificationResult({
    required this.sent,
    required this.failed,
  });

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      sent: json['sent'] as int? ?? 0,
      failed: json['failed'] as int? ?? 0,
    );
  }

  int get total => sent + failed;
  bool get hasFailures => failed > 0;
}
