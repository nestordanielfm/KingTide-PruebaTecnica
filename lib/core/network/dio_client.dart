import 'package:dio/dio.dart';
import 'package:template_app/core/config/environment.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: EnvironmentConfig.connectionTimeout,
        receiveTimeout: EnvironmentConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    if (EnvironmentConfig.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: EnvironmentConfig.isDev,
          responseBody: EnvironmentConfig.isDev,
          error: true,
          requestHeader: EnvironmentConfig.isDev,
          responseHeader: false,
        ),
      );
    }

    // Add auth interceptor if needed
    dio.interceptors.add(AuthInterceptor());
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // final token = getIt<TokenStorage>().getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 globally
    if (err.response?.statusCode == 401) {
      // Clear token and navigate to login
    }
    super.onError(err, handler);
  }
}
