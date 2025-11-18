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

import '../../modules/pokemon/data/datasources/pokemon_data_source.dart'
    as _i1026;
import '../../modules/pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i337;
import '../../modules/pokemon/domain/repositories/i_pokemon_repository.dart'
    as _i81;
import '../../modules/pokemon/domain/usecases/get_pokemon_use_case.dart'
    as _i158;
import '../../modules/pokemon/presentation/bloc/pokemon_bloc.dart' as _i561;
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
    gh.factory<_i1026.IPokemonDataSource>(
      () => _i1026.PokemonDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i81.IPokemonRepository>(
      () => _i337.PokemonRepositoryImpl(gh<_i1026.IPokemonDataSource>()),
    );
    gh.factory<_i158.IGetPokemonUseCase>(
      () => _i158.GetPokemonUseCase(gh<_i81.IPokemonRepository>()),
    );
    gh.factory<_i561.PokemonBloc>(
      () => _i561.PokemonBloc(gh<_i158.IGetPokemonUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
