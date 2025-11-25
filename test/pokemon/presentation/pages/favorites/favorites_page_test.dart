import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/pages/favorites/pokemon_favorites_page.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_card.dart';

class MockFavoriteBloc extends MockBloc<FavoriteEvent, FavoriteState>
    implements FavoriteBloc {}

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

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
);

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class TestHttpOverrides extends HttpOverrides {
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
    when(
      () => response.compressionState,
    ).thenReturn(HttpClientResponseCompressionState.notCompressed);

    when(() => response.listen(any())).thenAnswer((invocation) {
      final onData =
          invocation.positionalArguments[0] as void Function(List<int>);
      onData(_transparentImage);
      return Stream<List<int>>.fromIterable([_transparentImage]).listen(null);
    });

    return client;
  }
}

void main() {
  late MockFavoriteBloc favoriteBloc;
  late MockAppTypography typography;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
    registerFallbackValue(LoadFavoritesEvent());
  });

  setUp(() {
    favoriteBloc = MockFavoriteBloc();
    typography = MockAppTypography();
  });

  final tPokemon = PokemonEntity(
    id: 1,
    name: 'Bulbasaur',
    imageUrl: 'https://fake.url/img.png',
  );

  testWidgets('Should display "Nenhum favorito" when list is empty', (
    tester,
  ) async {
    when(
      () => favoriteBloc.state,
    ).thenReturn(const FavoriteLoadedState(favorites: [], favoriteIds: {}));

    await tester.pumpWidget(
      MaterialApp(home: PokemonFavoritesPage(bloc: favoriteBloc, typography: typography)),
    );
    await tester.pump();

    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
    expect(find.byType(PokemonCard), findsNothing);
  });

  testWidgets('Should display Pokemon Cards when list has items', (
    tester,
  ) async {
    when(
      () => favoriteBloc.state,
    ).thenReturn(FavoriteLoadedState(favorites: [tPokemon], favoriteIds: {1}));

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(home: PokemonFavoritesPage(bloc: favoriteBloc, typography: typography)),
      );

      await tester.pump();
    });

    expect(find.text('Nenhum favorito ainda'), findsNothing);
    expect(find.byType(PokemonCard), findsOneWidget);
    expect(find.text('BULBASAUR'), findsOneWidget);
  });
}
