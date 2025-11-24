import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/detail/pokemon_detail_page.dart';

class MockPokemonDetailBloc
    extends MockBloc<PokemonDetailEvent, PokemonDetailState>
    implements PokemonDetailBloc {}

class MockFavoriteBloc extends MockBloc<FavoriteEvent, FavoriteState>
    implements FavoriteBloc {}

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
);

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class FakeUri extends Fake implements Uri {}

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

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = MockHttpClient();

    when(() => client.autoUncompress).thenReturn(false);
    when(() => client.autoUncompress = any()).thenReturn(false);

    Future<HttpClientRequest> handleRequest(Invocation invocation) async {
      final request = MockHttpClientRequest();
      final headers = MockHttpHeaders();
      
      when(() => request.headers).thenReturn(headers);
      when(() => request.close()).thenAnswer((_) async {
        final response = StreamMockHttpClientResponse(_transparentImage);
        
        when(() => response.statusCode).thenReturn(200);
        when(() => response.contentLength).thenReturn(_transparentImage.length);
        when(() => response.compressionState).thenReturn(HttpClientResponseCompressionState.notCompressed);
        when(() => response.headers).thenReturn(headers);
        when(() => response.isRedirect).thenReturn(false);
        
        return response;
      });

      return request;
    }

    when(() => client.getUrl(any())).thenAnswer(handleRequest);
    return client;
  }
}

void main() {
  late MockPokemonDetailBloc detailBloc;
  late MockFavoriteBloc favoriteBloc;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final fontNames = ['Poppins', 'Press Start 2P', 'PressStart2P'];

    for (final name in fontNames) {
      final fontLoader = FontLoader(name);
      fontLoader.addFont(Future.value(ByteData(0)));
      await fontLoader.load();
    }

    HttpOverrides.global = MockHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;

    registerFallbackValue(FakeUri());
    registerFallbackValue(const FetchPokemonDetailEvent(1));
    registerFallbackValue(LoadFavoritesEvent());
  });

  setUp(() {
    detailBloc = MockPokemonDetailBloc();
    favoriteBloc = MockFavoriteBloc();

    GetIt.I.reset();

    when(() => detailBloc.add(any())).thenReturn(null);
    when(() => favoriteBloc.add(any())).thenReturn(null);
    when(() => detailBloc.close()).thenAnswer((_) async {});
    when(() => favoriteBloc.close()).thenAnswer((_) async {});
    when(() => favoriteBloc.state).thenReturn(FavoriteInitialState());
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

  testWidgets('Should display Loading Indicator when state is Loading', (
    tester,
  ) async {
    when(() => detailBloc.state).thenReturn(PokemonDetailLoadingState());

    await tester.pumpWidget(
      MaterialApp(home: PokemonDetailPage(id: 1, bloc: detailBloc)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display Error Message when state is Error', (
    tester,
  ) async {
    const msg = 'Erro ao carregar detalhes';
    when(() => detailBloc.state).thenReturn(const PokemonDetailErrorState(msg));

    await tester.pumpWidget(
      MaterialApp(home: PokemonDetailPage(id: 1, bloc: detailBloc)),
    );

    expect(find.text(msg), findsOneWidget);
  });

  testWidgets('Should display Pokemon Details when state is Success', (
    tester,
  ) async {
    when(() => detailBloc.state).thenReturn(PokemonDetailSuccessState(tDetail));
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: PokemonDetailPage(
            id: 1,
            bloc: detailBloc,
            favoriteBloc: favoriteBloc,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
    });

    expect(find.text('CHARIZARD'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.text('FIRE'), findsOneWidget);

    expect(find.byType(Image), findsOneWidget);
  });

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
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
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
        MaterialApp(
          home: PokemonDetailPage(
            id: 1,
            bloc: detailBloc,
            favoriteBloc: favoriteBloc,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
    });

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });
}
