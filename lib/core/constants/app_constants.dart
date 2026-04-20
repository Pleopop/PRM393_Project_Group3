class AppConstants {
  AppConstants._();

  // API
  // static const String baseUrl = 'https://192.168.1.11:8080'; // test on true device
  static const String baseUrl = 'https://localhost:8080';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Routes
  static const String routeLogin = '/login';
  static const String routeDashboard = '/dashboard';
  static const String routeProfile = '/profile';
  static const String routeRank = '/rank';
  static const String routePolicies = '/policies';
  static const String routeStats = '/stats';

}
