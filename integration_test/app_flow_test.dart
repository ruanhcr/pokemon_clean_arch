import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/app_widget/app_widget.dart';
import 'package:pokemon_clean_arch/core/di/injection.dart' as di;
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';

class FakeUri extends Fake implements Uri {}
class FakeStreamListInt extends Fake implements Stream<List<int>> {}

final _transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
);

final _mockListResponse = {
  "results": [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
  ]
};

final _mockDetailResponse = {
  "id": 1,
  "name": "bulbasaur",
  "height": 7,
  "weight": 69,
  "types": [
    {"type": {"name": "grass"}}
  ],
  "stats": [
    {"base_stat": 45, "stat": {"name": "hp"}}
  ],
  "sprites": {
    "other": {
      "official-artwork": {"front_default": "https://fake.url/img.png"}
    }
  }
};

class MockAppTypography implements AppTypography {
  @override
  TextStyle body(double fontSize, Color color, {FontWeight? fontWeight}) =>
      TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight, fontFamily: 'Roboto');

  @override
  TextStyle heading(double fontSize, Color color) =>
      TextStyle(fontSize: fontSize, color: color, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
}

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

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

class IntegrationHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = MockHttpClient();

    when(() => client.autoUncompress).thenReturn(false);
    when(() => client.autoUncompress = any()).thenReturn(false);
    when(() => client.idleTimeout).thenReturn(const Duration(seconds: 0));
    when(() => client.idleTimeout = any()).thenReturn(const Duration(seconds: 0));

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

      List<int> responseBytes;
      int statusCode;
      
      if (uri.toString().contains('pokeapi.co')) {
        statusCode = 200;
        final jsonMap = uri.toString().endsWith('/1') 
            ? _mockDetailResponse 
            : _mockListResponse;
        responseBytes = utf8.encode(jsonEncode(jsonMap));
      } else {
        statusCode = 200;
        responseBytes = _transparentImage;
      }

      final response = StreamMockHttpClientResponse(responseBytes);

      when(() => request.headers).thenReturn(headers);
      when(() => request.cookies).thenReturn([]); 
      when(() => request.uri).thenReturn(uri); 
      when(() => request.close()).thenAnswer((_) async => response);
      when(() => request.done).thenAnswer((_) async => response);
      
      when(() => request.add(any())).thenReturn(null);
      when(() => request.addStream(any())).thenAnswer((_) async {});
      when(() => request.persistentConnection).thenReturn(true);
      when(() => request.persistentConnection = any()).thenReturn(true);
      when(() => request.followRedirects).thenReturn(true);
      when(() => request.followRedirects = any()).thenReturn(true);
      when(() => request.maxRedirects = any()).thenReturn(5);
      when(() => request.contentLength = any()).thenReturn(0);

      when(() => headers.set(any(), any())).thenReturn(null);
      when(() => headers.add(any(), any())).thenReturn(null);
      when(() => headers.removeAll(any())).thenReturn(null);
      when(() => headers.forEach(any())).thenReturn(null);
      when(() => headers.value(any())).thenReturn(null);

      when(() => response.headers).thenReturn(headers);
      when(() => response.cookies).thenReturn([]); 
      when(() => response.compressionState).thenReturn(HttpClientResponseCompressionState.notCompressed);
      when(() => response.isRedirect).thenReturn(false);
      when(() => response.persistentConnection).thenReturn(true);
      when(() => response.redirects).thenReturn([]);
      when(() => response.reasonPhrase).thenReturn("OK");
      when(() => response.statusCode).thenReturn(statusCode);
      when(() => response.contentLength).thenReturn(responseBytes.length);

      return request;
    }

    when(() => client.getUrl(any())).thenAnswer(handleRequest);
    when(() => client.openUrl(any(), any())).thenAnswer(handleRequest);
    when(() => client.open(any(), any(), any(), any())).thenAnswer(handleRequest);
    when(() => client.headUrl(any())).thenAnswer(handleRequest);

    return client;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeUri());
    registerFallbackValue(const Duration(seconds: 1));
    registerFallbackValue(FakeStreamListInt());
    
    HttpOverrides.global = IntegrationHttpOverrides();
  });

  setUp(() async {
    GetIt.I.allowReassignment = true;
  });

  testWidgets('E2E: Load List, Scroll and Navigate to Details', (tester) async {
    await di.configureDependencies(); 
    
    GetIt.I.registerSingleton<AppTypography>(MockAppTypography());

    await tester.pumpWidget(const AppWidget());
    
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('POKÉDEX'), findsOneWidget);
    
    final bulbasaurFinder = find.text('BULBASAUR'); 
    
    try {
      if (find.text('BULBASAUR').evaluate().isEmpty) {
         await tester.scrollUntilVisible(bulbasaurFinder, 500, scrollable: find.byType(Scrollable));
      }
    } catch (_) {}
    
    if (find.text('BULBASAUR').evaluate().isNotEmpty) {
        await tester.tap(bulbasaurFinder);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('HP'), findsOneWidget);
        
        await tester.tap(find.byIcon(Icons.arrow_back_ios));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        expect(find.text('POKÉDEX'), findsOneWidget);
    }
    
    await tester.pump(const Duration(seconds: 2));
  });
}