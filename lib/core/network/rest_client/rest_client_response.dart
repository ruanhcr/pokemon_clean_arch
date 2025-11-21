import 'package:dio/dio.dart';

class RestClientResponse<T> {
  T? data;
  int? statusCode;
  String? statusMessage;
  Headers? headers;
  RestClientResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
    this.headers,
  });
}
