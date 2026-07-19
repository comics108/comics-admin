import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_config.dart';

class EnvConfig {
  EnvConfig._();

  static String get prodApiUrl => dotenv.env['PROD_API_URL'] ?? 'https://app.mbharata.com/api/v2026/admin';
  static String get devApiUrl => dotenv.env['DEV_API_URL'] ?? 'https://dev.mbharata.com/api/v2026/admin';
  static String get localApiUrl => dotenv.env['LOCAL_API_URL'] ?? 'http://localhost:3000/api/v2026/admin';

  static String getApiUrl(AppEnvironment environment) {
    switch (environment) {
      case AppEnvironment.prod:
        return prodApiUrl;
      case AppEnvironment.dev:
        return devApiUrl;
      case AppEnvironment.local:
        return localApiUrl;
      case AppEnvironment.mock:
        return ''; // No API in mock mode
    }
  }
}
