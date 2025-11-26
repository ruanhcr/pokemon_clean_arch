import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/api/endpoints.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client_response.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/remote/pokemon_remote_data_source_impl.dart';

class MockRestClient extends Mock implements RestClient {}

void main() {
  late PokemonRemoteDataSourceImpl dataSource;
  late MockRestClient client;

  setUp(() {
    client = MockRestClient();
    dataSource = PokemonRemoteDataSourceImpl(client: client);
  });

  final tJsonList = {
    "results": [
      {"name": "bulbasaur", "url": ".../1/"},
    ],
  };

  final tJsonDetail = {"id": 1, "name": "bulbasaur"};

  group('PokemonRemoteDataSource', () {
    test(
      'Should call RestClient.get with correct URL and Parameters for List',
      () async {
        when(
          () =>
              client.get(any(), queryParameters: any(named: 'queryParameters')),
        ).thenAnswer(
          (_) async => RestClientResponse(data: tJsonList, statusCode: 200),
        );

        final result = await dataSource.getPokemonList(offset: 10, limit: 30);

        expect(result, tJsonList['results']);

        verify(
          () => client.get(
            Endpoints.pokemon,
            queryParameters: {'offset': 10, 'limit': 30},
          ),
        ).called(1);
      },
    );

    test('Should call RestClient.get with correct URL for Details', () async {
      when(() => client.get(any())).thenAnswer(
        (_) async => RestClientResponse(data: tJsonDetail, statusCode: 200),
      );

      final result = await dataSource.getPokemonDetailById(1);

      expect(result, tJsonDetail);

      verify(() => client.get('${Endpoints.pokemon}/1')).called(1);
    });

    test('Should rethrow exceptions from RestClient', () async {
      when(
        () => client.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(Exception('Erro de conexão'));

      expect(() => dataSource.getPokemonList(), throwsA(isA<Exception>()));
    });
  });
}
