import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/list/pokemon_list_page.dart';

class MockPokemonListBloc extends MockBloc<PokemonListEvent, PokemonListState>
    implements PokemonListBloc {}

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
);

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = MockHttpClient();
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    when(() => client.getUrl(any())).thenAnswer((_) async => request);
    when(() => client.autoUncompress).thenReturn(false); 
    when(() => client.autoUncompress = any()).thenReturn(false);
    when(() => request.headers).thenReturn(headers);
    when(() => request.close()).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(HttpStatus.ok);
    when(() => response.contentLength).thenReturn(_transparentImage.length);
    when(() => response.listen(any())).thenAnswer((invocation) {
      final onData = invocation.positionalArguments[0] as void Function(List<int>);
      onData(_transparentImage); 
      return Stream<List<int>>.fromIterable([_transparentImage]).listen(null);
    });

    return client;
  }
}

void main() {
  late MockPokemonListBloc bloc;

  setUpAll(() { 
    HttpOverrides.global = MockHttpOverrides();
  });

  setUp(() {
    bloc = MockPokemonListBloc();
    when(() => bloc.close()).thenAnswer((_) async {});
  });

  final tPokemon = PokemonEntity(
    id: 1,
    name: 'Bulbasaur',
    imageUrl: 'https://fake.url/1.png',
  );

  testWidgets('Should display Loading Indicator when state is Loading', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(PokemonListLoadingState());

    await tester.pumpWidget(MaterialApp(home: PokemonListPage(bloc: bloc,)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display Error Message when state is Error', (
    tester,
  ) async {
    const msg = 'Erro de conexão';
    when(() => bloc.state).thenReturn(const PokemonListErrorState(msg));

    await tester.pumpWidget(MaterialApp(home: PokemonListPage(bloc: bloc,)));

    expect(find.text(msg), findsOneWidget);
  });

testWidgets('Should display Pokemon Grid when state is Success', (tester) async {
    when(() => bloc.state).thenReturn(
      PokemonListSuccessState(pokemons: [tPokemon], hasReachedMax: true),
    );

    await tester.pumpWidget(MaterialApp(
      home: PokemonListPage(bloc: bloc),
    ));
    await tester.pump(); 

    expect(find.text('BULBASAUR'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
  });
}