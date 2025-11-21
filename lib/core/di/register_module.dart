import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/api/endpoints.dart';

@module
abstract class RegisterModule {

  @singleton
  Dio get dio => Dio(BaseOptions(
    baseUrl: Endpoints.baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));
}