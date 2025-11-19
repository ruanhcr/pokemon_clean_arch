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

import '../../modules/pokemon/data/datasources/i_pokemon_data_source.dart'
    as _i371;
import '../../modules/pokemon/data/datasources/pokemon_data_source.dart'
    as _i1026;
import '../../modules/pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i337;
import '../../modules/pokemon/domain/repositories/i_pokemon_repository.dart'
    as _i81;
import '../../modules/pokemon/domain/usecases/get_pokemon_details_use_case.dart'
    as _i171;
import '../../modules/pokemon/domain/usecases/get_pokemon_list_use_case.dart'
    as _i155;
import '../../modules/pokemon/domain/usecases/get_pokemon_use_case.dart'
    as _i158;
import '../../modules/pokemon/domain/usecases/i_get_pokemon_details_use_case.dart'
    as _i980;
import '../../modules/pokemon/domain/usecases/i_get_pokemon_list_use_case.dart'
    as _i551;
import '../../modules/pokemon/domain/usecases/i_get_pokemon_use_case.dart'
    as _i667;
import '../../modules/pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart'
    as _i337;
import '../../modules/pokemon/presentation/bloc/list/pokemon_list_bloc.dart'
    as _i235;
import '../../modules/pokemon/presentation/bloc/search/pokemon_search_bloc.dart'
    as _i1021;
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
    gh.factory<_i371.IPokemonDataSource>(
      () => _i1026.PokemonDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i81.IPokemonRepository>(
      () => _i337.PokemonRepositoryImpl(gh<_i371.IPokemonDataSource>()),
    );
    gh.factory<_i980.IGetPokemonDetailsUseCase>(
      () => _i171.GetPokemonDetailsUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i551.IGetPokemonListUseCase>(
      () => _i155.GetPokemonListUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i235.PokemonListBloc>(
      () => _i235.PokemonListBloc(gh<_i551.IGetPokemonListUseCase>()),
    );
    gh.factory<_i667.IGetPokemonUseCase>(
      () => _i158.GetPokemonUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i1021.PokemonSearchBloc>(
      () => _i1021.PokemonSearchBloc(gh<_i667.IGetPokemonUseCase>()),
    );
    gh.factory<_i337.PokemonDetailBloc>(
      () => _i337.PokemonDetailBloc(gh<_i980.IGetPokemonDetailsUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
