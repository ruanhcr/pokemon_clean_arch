import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/search_pokemon_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_state.dart';

class MockSearchPokemonUseCase extends Mock implements SearchPokemonUseCase {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockSearchPokemonUseCase searchPokemonUseCase;
  late PokemonSearchBloc bloc;
  late MockAppLogger log;

  setUp(() {
    searchPokemonUseCase = MockSearchPokemonUseCase();
    log = MockAppLogger();
    bloc = PokemonSearchBloc(
      searchPokemonUseCase: searchPokemonUseCase,
      log: log,
    );
  });

  final tPokemon = PokemonEntity(id: 1, name: 'bulbasaur', imageUrl: 'img1');

  blocTest<PokemonSearchBloc, PokemonSearchState>(
    'Should emit [Loading, Success] when success in return data',
    build: () {
      when(
        () => searchPokemonUseCase.call('bulbasaur'),
      ).thenAnswer((_) async => Right(tPokemon));
      return bloc;
    },

    act: (bloc) => bloc.add(SearchPokemonEvent('bulbasaur')),

    wait: const Duration(milliseconds: 500),

    expect: () => [
      PokemonSearchLoadingState(),
      PokemonSearchSuccessState(tPokemon),
    ],
  );

  blocTest<PokemonSearchBloc, PokemonSearchState>(
    'Should emit [Loading, Error] and Log when usecase returns NotFoundFailure',
    build: () {
      when(
        () => searchPokemonUseCase.call('pikach'),
      ).thenAnswer((_) async => Left(NotFoundFailure()));

      return bloc;
    },

    act: (bloc) => bloc.add(SearchPokemonEvent('pikach')),

    wait: const Duration(milliseconds: 500),

    expect: () => [
      PokemonSearchLoadingState(),
      const PokemonSearchErrorState(
        'Ops! Não encontramos nenhum Pokémon com esse nome.',
      ),
    ],

    verify: (_) {
      verify(() => log.error(any(), any())).called(1);
    },
  );
}
