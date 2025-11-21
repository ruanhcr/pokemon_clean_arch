import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/detail/pokemon_detail_page.dart';

class MockPokemonDetailBloc extends MockBloc<PokemonDetailEvent, PokemonDetailState>
    implements PokemonDetailBloc {}

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
);

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}
class FakeUri extends Fake implements Uri {}

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
    when(() => response.compressionState)
        .thenReturn(HttpClientResponseCompressionState.notCompressed);
    when(() => response.contentLength).thenReturn(_transparentImage.length);

    when(() => response.listen(
          any(),
          onDone: any(named: 'onDone'),
          onError: any(named: 'onError'),
          cancelOnError: any(named: 'cancelOnError'),
        )).thenAnswer((invocation) {
      final onData =
          invocation.positionalArguments[0] as void Function(List<int>);
      final onDone = invocation.namedArguments[#onDone] as void Function()?;
      final onError = invocation.namedArguments[#onError] as Function?;
      final cancelOnError = invocation.namedArguments[#cancelOnError] as bool?;

      return Stream<List<int>>.fromIterable([_transparentImage]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
    });

    return client;
  }
}

void main() {
  late MockPokemonDetailBloc bloc;

  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;
    registerFallbackValue(FakeUri());
    registerFallbackValue(const FetchPokemonDetailEvent(1));
  });

  setUp(() {
    bloc = MockPokemonDetailBloc();
    
    when(() => bloc.add(any())).thenReturn(null);
    
    when(() => bloc.close()).thenAnswer((_) async {});
  });

  final tDetail = PokemonDetailEntity(
    id: 1,
    name: 'Charizard',
    imageUrl: 'https://fake.url/img.png',
    height: 17,
    weight: 905,
    types: ['fire', 'flying'],
    stats: {'hp': 78, 'attack': 84},
  );

  testWidgets('Should display Loading Indicator when state is Loading', (tester) async {
    when(() => bloc.state).thenReturn(PokemonDetailLoadingState());

    await tester.pumpWidget(MaterialApp(
      home: PokemonDetailPage(id: 1, bloc: bloc),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display Error Message when state is Error', (tester) async {
    const msg = 'Erro ao carregar detalhes';
    when(() => bloc.state).thenReturn(const PokemonDetailErrorState(msg));

    await tester.pumpWidget(MaterialApp(
      home: PokemonDetailPage(id: 1, bloc: bloc),
    ));

    expect(find.text(msg), findsOneWidget);
  });

testWidgets('Should display Pokemon Details when state is Success', (tester) async {
    when(() => bloc.state).thenReturn(PokemonDetailSuccessState(tDetail));
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: PokemonDetailPage(id: 1, bloc: bloc),
      ));
      await tester.pump(const Duration(seconds: 1)); 
    });

    expect(find.text('CHARIZARD'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.text('FIRE'), findsOneWidget);
    
    expect(find.byType(Image), findsOneWidget);
  });
}