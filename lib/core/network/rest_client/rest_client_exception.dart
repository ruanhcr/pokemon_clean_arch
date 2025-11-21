// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client_response.dart';

class RestClientException implements Exception {
  String? message;
  String? titleErrorMessage;
  int? statusCode;
  dynamic error;
  RestClientResponse response;
  RestClientException({
    this.message,
    this.titleErrorMessage,
    this.statusCode,
    required this.error,
    required this.response,
  });

  @override
  String toString() {
    return 'RestClientException(titleErrorMessage: $titleErrorMessage, message: $message, statusCode: $statusCode, error: $error, response: $response)';
  }
}
