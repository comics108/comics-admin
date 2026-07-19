enum AppEnvironment { prod, dev, local, mock }

class AppConfig {
  final AppEnvironment environment;
  final String? apiUrl;
  final String? authToken;
  final String? userEmail;

  const AppConfig({
    required this.environment,
    this.apiUrl,
    this.authToken,
    this.userEmail,
  });

  bool get isMockMode => environment == AppEnvironment.mock;
  bool get isAuthenticated => authToken != null || isMockMode;

  AppConfig copyWith({
    AppEnvironment? environment,
    String? apiUrl,
    String? authToken,
    String? userEmail,
  }) {
    return AppConfig(
      environment: environment ?? this.environment,
      apiUrl: apiUrl ?? this.apiUrl,
      authToken: authToken ?? this.authToken,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  /// Determine environment based on login credentials
  static AppEnvironment getEnvironmentFromCredentials(String email, String password) {
    if (email == 'dev' && password == 'dev') {
      return AppEnvironment.dev;
    } else if (email == 'local' && password == 'local') {
      return AppEnvironment.local;
    } else if (email == 'maket' && password == 'maket') {
      return AppEnvironment.mock;
    }
    return AppEnvironment.prod;
  }
}
