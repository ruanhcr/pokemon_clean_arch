import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/detail/pokemon_detail_page.dart';

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
);

class FakeStreamListInt extends Fake implements Stream<List<int>> {}

// --- 2. MOCKS DE BLOC ---
class MockPokemonDetailBloc
    extends MockBloc<PokemonDetailEvent, PokemonDetailState>
    implements PokemonDetailBloc {}

class MockFavoriteBloc extends MockBloc<FavoriteEvent, FavoriteState>
    implements FavoriteBloc {}

// --- 3. MOCK DE TIPOGRAFIA (Sua implementação correta!) ---
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

// --- 4. MOCKS DE INFRAESTRUTURA HTTP (O Segredo para Image.network) ---
class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

// Mixin para Streams (Evita erro de tipo 'Null is not subtype of Stream')
class StreamMockHttpClientResponse extends Mock
    with Stream<List<int>>
    implements HttpClientResponse {
  final List<int> data;
  final Stream<List<int>> _stream;

  StreamMockHttpClientResponse(this.data)
    : _stream = Stream.fromIterable([data]);

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

// O Override que retorna a imagem fake imediatamente
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = MockHttpClient();

    when(() => client.autoUncompress).thenReturn(false);
    when(() => client.autoUncompress = any()).thenReturn(false);

    Future<HttpClientRequest> handleRequest(Invocation invocation) async {
      final request = MockHttpClientRequest();
      final headers = MockHttpHeaders();
      final uri = invocation.positionalArguments[0] as Uri;

      // Retorna sempre sucesso com a imagem transparente
      final response = StreamMockHttpClientResponse(_transparentImage);

      when(() => request.headers).thenReturn(headers);
      when(() => request.close()).thenAnswer((_) async => response);
      when(() => request.uri).thenReturn(uri);

      when(() => response.statusCode).thenReturn(200);
      when(() => response.contentLength).thenReturn(_transparentImage.length);
      when(
        () => response.compressionState,
      ).thenReturn(HttpClientResponseCompressionState.notCompressed);
      when(() => response.headers).thenReturn(headers);
      when(() => response.isRedirect).thenReturn(false);
      when(() => response.reasonPhrase).thenReturn("OK");

      return request;
    }

    when(() => client.getUrl(any())).thenAnswer(handleRequest);
    return client;
  }
}

void main() {
  late MockPokemonDetailBloc detailBloc;
  late MockFavoriteBloc favoriteBloc;
  late AppTypography typography;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MockHttpOverrides();
    registerFallbackValue(FakeStreamListInt());
    registerFallbackValue(Uri.parse('http://dummy.com'));
    registerFallbackValue(const FetchPokemonDetailEvent(1));
    registerFallbackValue(LoadFavoritesEvent());
  });

  setUp(() {
    detailBloc = MockPokemonDetailBloc();
    favoriteBloc = MockFavoriteBloc();
    typography = MockAppTypography();

    GetIt.I.reset();

    when(() => detailBloc.add(any())).thenReturn(null);
    when(() => favoriteBloc.add(any())).thenReturn(null);
    when(() => detailBloc.close()).thenAnswer((_) async {});
    when(() => favoriteBloc.close()).thenAnswer((_) async {});

    // Estados iniciais
    when(() => favoriteBloc.state).thenReturn(FavoriteInitialState());
    when(() => detailBloc.state).thenReturn(PokemonDetailInitialState());
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

  testWidgets('Should show Filled Heart icon when Pokemon IS favorite', (
    tester,
  ) async {
    when(() => detailBloc.state).thenReturn(PokemonDetailSuccessState(tDetail));
    when(
      () => favoriteBloc.state,
    ).thenReturn(FavoriteLoadedState(favorites: [], favoriteIds: {1}));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [BlocProvider<FavoriteBloc>.value(value: favoriteBloc)],
        child: MaterialApp(
          home: PokemonDetailPage(
            id: 1,
            bloc: detailBloc,
            favoriteBloc: favoriteBloc,
            typography: typography, // Injeção da sua abstração
          ),
        ),
      ),
    );

    // Pump para processar o microtask da imagem
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Should show Border Heart icon when Pokemon is NOT favorite', (
    tester,
  ) async {
    when(() => detailBloc.state).thenReturn(PokemonDetailSuccessState(tDetail));
    when(
      () => favoriteBloc.state,
    ).thenReturn(const FavoriteLoadedState(favorites: [], favoriteIds: {}));

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [BlocProvider<FavoriteBloc>.value(value: favoriteBloc)],
          child: MaterialApp(
            home: PokemonDetailPage(
              id: 1,
              bloc: detailBloc,
              favoriteBloc: favoriteBloc,
              typography: typography,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    });

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });
}
