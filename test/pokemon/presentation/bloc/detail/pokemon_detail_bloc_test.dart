import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_pokemon_details_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';

class MockPokemonDetailUseCase extends Mock
    implements IGetPokemonDetailsUseCase {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late PokemonDetailBloc bloc;
  late MockPokemonDetailUseCase useCase;
  late MockAppLogger log;

  setUp(() {
    useCase = MockPokemonDetailUseCase();
    log = MockAppLogger();
    bloc = PokemonDetailBloc(getPokemonDetailsUseCase: useCase, log: log);
  });

  final tPokemonDetails = PokemonDetailEntity(
    id: 1,
    name: 'Bulbasaur',
    imageUrl: 'img1',
    height: 100,
    weight: 200,
    types: ['Venom'],
    stats: {'hp': 45, 'attack': 49, 'defense': 49, 'speed': 45},
  );

  blocTest<PokemonDetailBloc, PokemonDetailState>(
    'Should emit [Loading, Success] when return data is successful ',
    build: () {
      when(
        () => useCase.call(1),
      ).thenAnswer((_) async => Right(tPokemonDetails));
      return bloc;
    },

    act: (bloc) => bloc.add(FetchPokemonDetailEvent(1)),

    expect: () => [
      PokemonDetailLoadingState(),
      PokemonDetailSuccessState(tPokemonDetails),
    ],
  );

  blocTest<PokemonDetailBloc, PokemonDetailState>(
    'Should emit [Loading, Error] and Log when usecase returns NotFoundFailure',
    build: () {
      when(() => useCase(0)).thenAnswer((_) async => Left(NotFoundFailure()));
      return bloc;
    },

    act: (bloc) => bloc.add(FetchPokemonDetailEvent(0)),

    expect: () => [
      PokemonDetailLoadingState(),
      PokemonDetailErrorState(
        'Ops! Não encontramos nenhum Pokémon com esse nome.',
      ),
    ],

    verify: (_) {
        verify(() => log.error(any(), any())).called(1);
      },
  );
}
