import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/search/pokemon_search_page.dart';

class MockPokemonSearchBloc extends MockBloc<PokemonSearchEvent, PokemonSearchState>
    implements PokemonSearchBloc {}

void main() {
  late MockPokemonSearchBloc bloc;

  setUp(() {
    bloc = MockPokemonSearchBloc();
  });

  final tPokemon = PokemonEntity(id: 1, name: 'Pikachu', imageUrl: 'img1');

  testWidgets('Should display Initial Message when state is Initial', (tester) async {
    when(() => bloc.state).thenReturn(PokemonSearchInitialState());

    await tester.pumpWidget(MaterialApp(home: PokemonSearchPage(bloc: bloc,)));

    expect(find.text('Digite o nome do Pokémon para buscar'), findsOneWidget);
  });

  testWidgets('Should display Pokemon Card when state is Success', (tester) async {
    when(() => bloc.state).thenReturn(PokemonSearchSuccessState(tPokemon));

    await tester.pumpWidget(MaterialApp(home: PokemonSearchPage(bloc: bloc,)));
    await tester.pump();

    expect(find.text('PIKACHU'), findsOneWidget);
    
    expect(find.text('ID: #001'), findsOneWidget);
  });
}