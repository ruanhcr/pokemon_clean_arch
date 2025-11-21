class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Erro de conexão"]);
}