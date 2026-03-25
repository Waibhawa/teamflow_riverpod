import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/app_exception.dart';

/// Singleton Dio instance with:
///   • Base URL + timeouts pre-configured
///   • Request logging (debug only)
///   • Error mapping: every DioException → typed AppException
class DioClient {
  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..interceptors.addAll([
        _LoggingInterceptor(),
        _ErrorInterceptor(),
      ]);
  }

  static final DioClient _instance = DioClient._();
  static DioClient get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;
}

/// Logs every request / response to the console (stripped in release builds).
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[DIO] → ${options.method} ${options.path}');
      return true;
    }());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[DIO] ← ${response.statusCode} ${response.requestOptions.path}');
      return true;
    }());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[DIO] ✗ ${err.type} ${err.requestOptions.path}');
      return true;
    }());
    handler.next(err);
  }
}

/// Translates every DioException into a typed AppException so that
/// the data layer never leaks Dio-specific types upward.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _map(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mapped,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        if (status == 404) return const NotFoundException();
        return ServerException(statusCode: status);

      case DioExceptionType.cancel:
        return const UnknownException('Request was cancelled.');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return const UnknownException();
    }
  }
}

/// Convenience extension so the data layer can call
/// `dio.getOrThrow(...)` and always get a typed exception on failure.
extension SafeRequest on Dio {
  /// Performs a GET and re-throws any DioException as the embedded
  /// [AppException] that [_ErrorInterceptor] already attached.
  Future<Response<T>> getOrThrow<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw (e.error is AppException) ? e.error as AppException : const UnknownException();
    } catch (_) {
      throw const UnknownException();
    }
  }
}
