import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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

class FakeStreamListInt extends Fake implements Stream<List<int>> {}

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
    when(() => client.idleTimeout).thenReturn(const Duration(seconds: 0));
    when(
      () => client.idleTimeout = any(),
    ).thenReturn(const Duration(seconds: 0));

    Future<HttpClientRequest> handleRequest(Invocation invocation) async {
      final request = MockHttpClientRequest();
      final headers = MockHttpHeaders();

      Uri uri;
      if (invocation.memberName == #openUrl) {
        uri = invocation.positionalArguments[1] as Uri;
      } else if (invocation.memberName == #open) {
        final host = invocation.positionalArguments[1] as String;
        final path = invocation.positionalArguments[3] as String;
        uri = Uri.parse('https://$host$path');
      } else {
        uri = invocation.positionalArguments[0] as Uri;
      }

      int statusCode;
      List<int> responseBytes;

      if (uri.toString().contains('fake.url')) {
        statusCode = 200;
        responseBytes = _transparentImage;
      } else {
        statusCode = 404;
        responseBytes = [];
      }

      final response = StreamMockHttpClientResponse(responseBytes);

      when(() => request.headers).thenReturn(headers);
      when(() => request.close()).thenAnswer((_) async => response);
      when(() => request.done).thenAnswer((_) async => response);
      when(() => request.uri).thenReturn(uri);

      when(() => request.persistentConnection).thenReturn(true);
      when(() => request.persistentConnection = any()).thenReturn(true);
      when(() => request.followRedirects).thenReturn(true);
      when(() => request.followRedirects = any()).thenReturn(true);
      when(() => request.maxRedirects = any()).thenReturn(5);
      when(() => request.contentLength = any()).thenReturn(0);
      when(() => request.add(any())).thenReturn(null);
      when(() => request.addStream(any())).thenAnswer((_) async {});

      when(() => response.statusCode).thenReturn(statusCode);
      when(() => response.contentLength).thenReturn(responseBytes.length);
      when(
        () => response.compressionState,
      ).thenReturn(HttpClientResponseCompressionState.notCompressed);
      when(() => response.headers).thenReturn(headers);
      when(() => response.cookies).thenReturn([]);
      when(() => response.isRedirect).thenReturn(false);
      when(() => response.persistentConnection).thenReturn(true);
      when(() => response.redirects).thenReturn([]);
      when(() => response.reasonPhrase).thenReturn("OK");

      when(() => headers.set(any(), any())).thenReturn(null);
      when(() => headers.add(any(), any())).thenReturn(null);
      when(() => headers.removeAll(any())).thenReturn(null);
      when(() => headers.forEach(any())).thenReturn(null);
      when(() => headers.value(any())).thenReturn(null);

      return request;
    }

    when(() => client.getUrl(any())).thenAnswer(handleRequest);
    when(() => client.openUrl(any(), any())).thenAnswer(handleRequest);
    when(
      () => client.open(any(), any(), any(), any()),
    ).thenAnswer(handleRequest);
    when(() => client.headUrl(any())).thenAnswer(handleRequest);

    return client;
  }
}

void main() {
  late MockPokemonDetailBloc detailBloc;
  late MockFavoriteBloc favoriteBloc;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(const Duration(seconds: 1));

    HttpOverrides.global = MockHttpOverrides();

    GoogleFonts.config.allowRuntimeFetching = true;

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final errorMsg = details.exception.toString();
      if (errorMsg.contains('google_fonts') || errorMsg.contains('load font')) {
        return;
      }
      originalOnError?.call(details);
    };

    registerFallbackValue(const FetchPokemonDetailEvent(1));
    registerFallbackValue(LoadFavoritesEvent());
    registerFallbackValue(FakeStreamListInt());
  });

  setUp(() {
    detailBloc = MockPokemonDetailBloc();
    favoriteBloc = MockFavoriteBloc();

    GetIt.I.reset();

    GetIt.I.registerSingleton<FavoriteBloc>(favoriteBloc);
    GetIt.I.registerSingleton<PokemonDetailBloc>(detailBloc);

    when(() => detailBloc.add(any())).thenReturn(null);
    when(() => favoriteBloc.add(any())).thenReturn(null);
    when(() => detailBloc.close()).thenAnswer((_) async {});
    when(() => favoriteBloc.close()).thenAnswer((_) async {});

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

    await tester.runAsync(() async {
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
      await tester.pump(const Duration(milliseconds: 500));
    });

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
        MultiBlocProvider(
          providers: [BlocProvider<FavoriteBloc>.value(value: favoriteBloc)],
          child: MaterialApp(home: PokemonDetailPage(id: 1, bloc: detailBloc)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    });

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });
}
