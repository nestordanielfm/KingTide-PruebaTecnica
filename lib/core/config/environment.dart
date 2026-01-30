import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { dev, prod }

class EnvironmentConfig {
  static late Environment _environment;

  static void init({String? env}) {
    _environment = env == 'prod' ? Environment.prod : Environment.dev;
  }

  static Environment get environment => _environment;
  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;

  // API URLs
  static String get futuramaApiUrl =>
      dotenv.get('FUTURAMA_API_URL', fallback: 'https://futuramaapi.com/api');

  static String get omdbApiUrl =>
      dotenv.get('OMDB_API_URL', fallback: 'http://www.omdbapi.com');

  static String get omdbApiKey => dotenv.get('OMDB_API_KEY', fallback: '');

  // Network Configuration
  static Duration get connectionTimeout => Duration(
    seconds: int.parse(dotenv.get('CONNECTION_TIMEOUT', fallback: '30')),
  );

  static Duration get receiveTimeout => Duration(
    seconds: int.parse(dotenv.get('RECEIVE_TIMEOUT', fallback: '30')),
  );

  // Feature Flags
  static bool get enableLogging =>
      dotenv.get('ENABLE_LOGGING', fallback: 'false').toLowerCase() == 'true';

  static bool get enableMockData =>
      dotenv.get('ENABLE_MOCK_DATA', fallback: 'false').toLowerCase() == 'true';
}
