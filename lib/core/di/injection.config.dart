// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;

import '../../pokemon/data/datasources/local/i_pokemon_local_data_source.dart'
    as _i234;
import '../../pokemon/data/datasources/local/pokemon_local_data_source.dart'
    as _i1036;
import '../../pokemon/data/datasources/remote/i_pokemon_remote_data_source.dart'
    as _i752;
import '../../pokemon/data/datasources/remote/pokemon_remote_data_source.dart'
    as _i685;
import '../../pokemon/data/models/pokemon_hive_model.dart' as _i332;
import '../../pokemon/data/repositories/pokemon_repository_impl.dart' as _i598;
import '../../pokemon/domain/repositories/i_pokemon_repository.dart' as _i886;
import '../../pokemon/domain/usecases/get_favorites_use_case.dart' as _i195;
import '../../pokemon/domain/usecases/get_pokemon_details_use_case.dart'
    as _i309;
import '../../pokemon/domain/usecases/get_pokemon_list_use_case.dart' as _i1050;
import '../../pokemon/domain/usecases/i_get_favorites_use_case.dart' as _i46;
import '../../pokemon/domain/usecases/i_get_pokemon_details_use_case.dart'
    as _i303;
import '../../pokemon/domain/usecases/i_get_pokemon_list_use_case.dart'
    as _i1033;
import '../../pokemon/domain/usecases/i_is_favorite_use_case.dart' as _i714;
import '../../pokemon/domain/usecases/i_remove_favorite_use_case.dart' as _i743;
import '../../pokemon/domain/usecases/i_save_favorite_use_case.dart' as _i973;
import '../../pokemon/domain/usecases/i_search_pokemon_use_case.dart' as _i570;
import '../../pokemon/domain/usecases/is_favorite_use_case.dart' as _i1044;
import '../../pokemon/domain/usecases/remove_favorite_use_case.dart' as _i1039;
import '../../pokemon/domain/usecases/save_favorite_use_case.dart' as _i766;
import '../../pokemon/domain/usecases/search_pokemon_use_case.dart' as _i305;
import '../../pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart'
    as _i268;
import '../../pokemon/presentation/bloc/favorites/favorite_bloc.dart' as _i760;
import '../../pokemon/presentation/bloc/list/pokemon_list_bloc.dart' as _i962;
import '../../pokemon/presentation/bloc/search/pokemon_search_bloc.dart'
    as _i594;
import '../log/app_logger.dart' as _i564;
import '../log/logger_app_logger_impl.dart' as _i700;
import '../network/rest_client/dio_rest_client.dart' as _i803;
import '../network/rest_client/rest_client.dart' as _i682;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    await gh.factoryAsync<_i986.Box<_i332.PokemonHiveModel>>(
      () => registerModule.favoritesBox,
      instanceName: 'favorites_box',
      preResolve: true,
    );
    gh.singleton<_i564.AppLogger>(() => _i700.LoggerAppLoggerImpl());
    gh.factory<_i234.IPokemonLocalDataSource>(() =>
        _i1036.PokemonLocalDataSourceImpl(gh<_i979.Box<_i332.PokemonHiveModel>>(
            instanceName: 'favorites_box')));
    gh.factory<_i682.RestClient>(() => _i803.DioRestClient(
          gh<_i361.Dio>(),
          log: gh<_i564.AppLogger>(),
        ));
    gh.factory<_i752.IPokemonRemoteDataSource>(
        () => _i685.PokemonRemoteDataSource(gh<_i682.RestClient>()));
    gh.factory<_i886.IPokemonRepository>(() => _i598.PokemonRepositoryImpl(
          gh<_i752.IPokemonRemoteDataSource>(),
          gh<_i234.IPokemonLocalDataSource>(),
        ));
    gh.factory<_i714.IIsFavoriteUseCase>(() =>
        _i1044.IsFavoriteUseCase(repository: gh<_i886.IPokemonRepository>()));
    gh.factory<_i743.IRemoveFavoriteUseCase>(() => _i1039.RemoveFavoriteUseCase(
        repository: gh<_i886.IPokemonRepository>()));
    gh.factory<_i303.IGetPokemonDetailsUseCase>(() =>
        _i309.GetPokemonDetailsUseCase(
            repository: gh<_i886.IPokemonRepository>()));
    gh.factory<_i46.IGetFavoritesUseCase>(() =>
        _i195.GetFavoritesUseCase(repository: gh<_i886.IPokemonRepository>()));
    gh.factory<_i1033.IGetPokemonListUseCase>(() =>
        _i1050.GetPokemonListUseCase(
            repository: gh<_i886.IPokemonRepository>()));
    gh.factory<_i570.ISearchPokemonUseCase>(() =>
        _i305.SearchPokemonUseCase(repository: gh<_i886.IPokemonRepository>()));
    gh.factory<_i973.ISaveFavoriteUseCase>(() =>
        _i766.SaveFavoriteUseCase(repository: gh<_i886.IPokemonRepository>()));
    gh.singleton<_i760.FavoriteBloc>(() => _i760.FavoriteBloc(
          gh<_i46.IGetFavoritesUseCase>(),
          gh<_i973.ISaveFavoriteUseCase>(),
          gh<_i743.IRemoveFavoriteUseCase>(),
          gh<_i564.AppLogger>(),
        ));
    gh.factory<_i962.PokemonListBloc>(() => _i962.PokemonListBloc(
          gh<_i1033.IGetPokemonListUseCase>(),
          gh<_i564.AppLogger>(),
        ));
    gh.factory<_i268.PokemonDetailBloc>(() => _i268.PokemonDetailBloc(
          gh<_i303.IGetPokemonDetailsUseCase>(),
          gh<_i564.AppLogger>(),
        ));
    gh.factory<_i594.PokemonSearchBloc>(() => _i594.PokemonSearchBloc(
          gh<_i570.ISearchPokemonUseCase>(),
          gh<_i564.AppLogger>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
