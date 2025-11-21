// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../pokemon/data/datasources/i_pokemon_data_source.dart'
    as _i371;
import '../../pokemon/data/datasources/pokemon_data_source.dart'
    as _i1026;
import '../../pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i337;
import '../../pokemon/domain/repositories/i_pokemon_repository.dart'
    as _i81;
import '../../pokemon/domain/usecases/get_pokemon_details_use_case.dart'
    as _i171;
import '../../pokemon/domain/usecases/get_pokemon_list_use_case.dart'
    as _i155;
import '../../pokemon/domain/usecases/i_get_pokemon_details_use_case.dart'
    as _i980;
import '../../pokemon/domain/usecases/i_get_pokemon_list_use_case.dart'
    as _i551;
import '../../pokemon/domain/usecases/i_search_pokemon_use_case.dart'
    as _i539;
import '../../pokemon/domain/usecases/search_pokemon_use_case.dart'
    as _i845;
import '../../pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart'
    as _i337;
import '../../pokemon/presentation/bloc/list/pokemon_list_bloc.dart'
    as _i235;
import '../../pokemon/presentation/bloc/search/pokemon_search_bloc.dart'
    as _i1021;
import '../log/app_logger.dart' as _i564;
import '../log/logger_app_logger_impl.dart' as _i700;
import '../network/rest_client/dio_rest_client.dart' as _i803;
import '../network/rest_client/rest_client.dart' as _i682;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i564.AppLogger>(() => _i700.LoggerAppLoggerImpl());
    gh.factory<_i682.RestClient>(
      () => _i803.DioRestClient(gh<_i361.Dio>(), log: gh<_i564.AppLogger>()),
    );
    gh.factory<_i371.IPokemonDataSource>(
      () => _i1026.PokemonDataSource(gh<_i682.RestClient>()),
    );
    gh.factory<_i81.IPokemonRepository>(
      () => _i337.PokemonRepositoryImpl(gh<_i371.IPokemonDataSource>()),
    );
    gh.factory<_i980.IGetPokemonDetailsUseCase>(
      () => _i171.GetPokemonDetailsUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i337.PokemonDetailBloc>(
      () => _i337.PokemonDetailBloc(
        gh<_i980.IGetPokemonDetailsUseCase>(),
        gh<_i564.AppLogger>(),
      ),
    );
    gh.factory<_i551.IGetPokemonListUseCase>(
      () => _i155.GetPokemonListUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i539.ISearchPokemonUseCase>(
      () => _i845.SearchPokemonUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i1021.PokemonSearchBloc>(
      () => _i1021.PokemonSearchBloc(
        gh<_i539.ISearchPokemonUseCase>(),
        gh<_i564.AppLogger>(),
      ),
    );
    gh.factory<_i235.PokemonListBloc>(
      () => _i235.PokemonListBloc(
        gh<_i551.IGetPokemonListUseCase>(),
        gh<_i564.AppLogger>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
