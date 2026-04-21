import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class ApiClient {
  ApiClient._internal() {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  /// Set this callback once at app startup to trigger logout on 401.
  static void Function()? onUnauthorized;

  final _storage = const FlutterSecureStorage();

  late final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
            connectTimeout: AppConstants.connectTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          _authInterceptor(),
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            logPrint: (o) => debugPrint(o.toString()),
          ),
        ]);

  // Attach Bearer token to every request
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.accessTokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          onUnauthorized?.call();
        }
        handler.next(e);
      },
    );
  }
}

// ignore: avoid_print
void debugPrint(String s) => print(s);
