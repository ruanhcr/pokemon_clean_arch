import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/exceptions/network_exception.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client_exception.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client_response.dart';

@Injectable(as: RestClient)
class DioRestClient implements RestClient {
  final Dio _dio;

  DioRestClient(this._dio, {required AppLogger log}) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers, method: method),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  Future<RestClientResponse<T>> _dioResponseConverter<T>(
    Response<dynamic> response,
  ) async {
    return RestClientResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers,
    );
  }

  Never _throwRestClientException(DioException dioError) {
    final response = dioError.response;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException("Verifique sua conexão com a internet.");

      case DioExceptionType.badResponse:
        final message = response?.data is Map
            ? response?.data['message']
            : response?.statusMessage ?? 'Erro no servidor';

        throw RestClientException(
          error: dioError.error,
          response: RestClientResponse(
            data: response?.data,
            statusCode: response?.statusCode,
            statusMessage: response?.statusMessage,
          ),
          message: message?.toString(),
          statusCode: response?.statusCode,
        );

      case DioExceptionType.cancel:
        throw RestClientException(
          error: dioError.error,
          response: RestClientResponse(
            data: response?.data,
            statusCode: response?.statusCode,
            statusMessage: response?.statusMessage,
          ),
          message: "A requisição foi cancelada.",
        );

      case DioExceptionType.unknown:
      default:
        throw RestClientException(
          error: dioError.error,
          response: RestClientResponse(
            data: response?.data,
            statusCode: response?.statusCode,
            statusMessage: response?.statusMessage,
          ),
          message: "Erro desconhecido na requisição: ${dioError.message}",
        );
    }
  }
}
