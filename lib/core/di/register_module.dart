import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/api/endpoints.dart';
import 'package:pokemon_clean_arch/core/helpers/string_constants.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

@module
abstract class RegisterModule {
  @singleton
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  @preResolve
  @Named(StringConstants.kHiveFavoritesBox)
  Future<Box<PokemonHiveModel>> get favoritesBox async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PokemonHiveModelAdapter());
    }

    return await Hive.openBox<PokemonHiveModel>(
      StringConstants.kHiveFavoritesBox,
    );
  }
}
