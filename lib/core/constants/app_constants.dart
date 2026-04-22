class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://52.65.122.242:8080';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String authUserKey = 'auth_user';
  static const String deviceIdKey = 'device_id';

  // Discord OAuth2
  static const String discordClientId = '1471451791865417893';

  // static const String discordRedirectUri = 'com.studybot.discord://callback';
  static const String discordRedirectUri =
      'http://52.65.122.242:8888/mobile-callback';
  static const String discordScopes = 'identify';

  // Routes
  static const String routeLogin = '/login';
  static const String routeCallback = '/callback';
  static const String routeDashboard = '/dashboard';
  static const String routeProfile = '/profile';
  static const String routeRank = '/rank';
  static const String routePolicies = '/policies';
  static const String routeStats = '/stats';
}
