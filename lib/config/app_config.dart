class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static String get apiUrl {
    switch (environment) {
      case 'staging':
        return 'https://staging.tu-api.com';

      case 'development':
      default:
        return 'https://dev.tu-api.com';
    }
  }

  static bool get isDevelopment {
    return environment == 'development';
  }

  static bool get isStaging {
    return environment == 'staging';
  }
}