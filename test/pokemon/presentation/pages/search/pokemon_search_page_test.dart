import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/search/pokemon_search_page.dart';

class MockPokemonSearchBloc
    extends MockBloc<PokemonSearchEvent, PokemonSearchState>
    implements PokemonSearchBloc {}

class MockAppTypography implements AppTypography {
  @override
  TextStyle body(double fontSize, Color color, {FontWeight? fontWeight}) {
    return TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight);
  }

  @override
  TextStyle heading(double fontSize, Color color) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}

void main() {
  late MockPokemonSearchBloc bloc;
  late MockAppTypography typography;

  setUp(() {
    bloc = MockPokemonSearchBloc();
    typography = MockAppTypography();
  });

  final tPokemon = PokemonEntity(id: 1, name: 'Pikachu', imageUrl: 'img1');

  testWidgets('Should display Initial Message when state is Initial', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(PokemonSearchInitialState());

    await tester.pumpWidget(
      MaterialApp(
        home: PokemonSearchPage(bloc: bloc, typography: typography),
      ),
    );

    expect(find.text('Digite o nome do Pokémon para buscar'), findsOneWidget);
  });

  testWidgets('Should display Pokemon Card when state is Success', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(PokemonSearchSuccessState(tPokemon));

    await tester.pumpWidget(
      MaterialApp(
        home: PokemonSearchPage(bloc: bloc, typography: typography),
      ),
    );
    await tester.pump();

    expect(find.text('PIKACHU'), findsOneWidget);

    expect(find.text('#001'), findsOneWidget);
  });
}
