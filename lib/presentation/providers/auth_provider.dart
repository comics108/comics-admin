import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../core/config/env_config.dart';
import '../../data/api/admin_api_client.dart';

final appConfigProvider = StateNotifierProvider<AppConfigNotifier, AppConfig?>((ref) {
  return AppConfigNotifier();
});

class AppConfigNotifier extends StateNotifier<AppConfig?> {
  AppConfigNotifier() : super(null);

  Future<bool> login(String email, String password) async {
    final environment = AppConfig.getEnvironmentFromCredentials(email, password);
    final apiUrl = EnvConfig.getApiUrl(environment);

    if (environment == AppEnvironment.mock) {
      // Mock mode - no API call needed
      state = AppConfig(
        environment: environment,
        apiUrl: apiUrl,
        authToken: 'mock_token',
        userEmail: 'maket',
      );
      return true;
    }

    // Real API login
    try {
      final client = AdminApiClient(apiUrl);
      final response = await client.login(email, password);

      if (response.success && response.data != null) {
        state = AppConfig(
          environment: environment,
          apiUrl: apiUrl,
          authToken: response.data!['token'] as String?,
          userEmail: email,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    state = null;
  }
}

final isAuthenticatedProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.isAuthenticated ?? false;
});

final currentUserEmailProvider = Provider<String?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.userEmail;
});

final isMockModeProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.isMockMode ?? false;
});
