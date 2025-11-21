import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_pokemon_list_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_state.dart';

class MockGetPokemonListUseCase extends Mock
    implements IGetPokemonListUseCase {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late PokemonListBloc bloc;
  late MockGetPokemonListUseCase useCase;
  late MockAppLogger log;

  setUp(() {
    useCase = MockGetPokemonListUseCase();
    log = MockAppLogger();
    bloc = PokemonListBloc(useCase, log);
  });

  final tPokemonList = [
    PokemonEntity(id: 1, name: 'Bulbasaur', imageUrl: 'img1'),
  ];

  final pokemon1 = PokemonEntity(id: 1, name: 'Bulbasaur', imageUrl: '');

  final pokemon2 = PokemonEntity(id: 2, name: 'Ivysaur', imageUrl: '');

group('PokemonListBloc', () {
    
    blocTest<PokemonListBloc, PokemonListState>(
      'Should emit [Loading, Success] when UseCase returns Right(data)',
      build: () {
        when(() => useCase(offset: 0))
            .thenAnswer((_) async => Right(tPokemonList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPokemonListEvent()),
      expect: () => [
        PokemonListLoadingState(),
        PokemonListSuccessState(pokemons: tPokemonList),
      ],
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'Should emit [Loading, Error] and Log when UseCase returns Left(failure)',
      build: () {
        when(() => useCase(offset: 0))
            .thenAnswer((_) async => Left(ServerFailure('Erro 500')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPokemonListEvent()),
      expect: () => [
        PokemonListLoadingState(),
        const PokemonListErrorState("Servidor instável: Erro 500"),
      ],
      verify: (_) {
        verify(() => log.error(any(), any())).called(1);
      },
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'Should concatenate list when loading second page with Success',
      build: () {
        when(() => useCase(offset: 1))
            .thenAnswer((_) async => Right([pokemon2]));
        return bloc;
      },
      seed: () => PokemonListSuccessState(pokemons: [pokemon1]),
      
      act: (bloc) => bloc.add(FetchPokemonListEvent()),
      
      expect: () => [
        PokemonListSuccessState(pokemons: [pokemon1, pokemon2]),
      ],
    );
  });
}
