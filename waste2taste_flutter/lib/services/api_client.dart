import 'package:dio/dio.dart';
import 'storage_service.dart';

/// App-wide configuration resolved from compile-time environment.
/// Pass --dart-define=API_URL=https://... to override.
/// Note: 10.0.2.2 is Android emulator's localhost; iOS simulator uses 127.0.0.1
class AppConfig {
  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}

/// Dio interceptor that attaches the JWT bearer token to every outgoing request
/// and handles 401 responses by clearing stored credentials.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._dio);

  final StorageService _storage;
  // ignore: unused_field
  final Dio _dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _storage.clearTokens();
      // Rethrow with a recognisable message so the provider layer can
      // redirect to login without coupling navigation to the HTTP layer.
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: err.error,
          message: 'session_expired',
        ),
      );
      return;
    }
    handler.next(err);
  }
}

class ApiClient {
  ApiClient(this._storage);

  final StorageService _storage;
  late final Dio _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(AuthInterceptor(_storage, _dio));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);
}
