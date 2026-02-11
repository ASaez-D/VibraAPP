import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/services/ticketmaster_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'ticketmaster_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  setUpAll(() async {
    // Correct way to load mock env in tests
    dotenv.testLoad(fileInput: 'TICKETMASTER_API_KEY=test_key');
  });

  group('TicketmasterService Tests', () {
    late TicketmasterService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = TicketmasterService(client: mockClient);
    });

    test('getConcerts returns list of concerts on 200 OK', () async {
      final jsonResponse = {
        '_embedded': {
          'events': [
            {
              'name': 'Test Concert',
              '_embedded': {
                'venues': [
                  {'name': 'Test Venue'},
                ],
              },
              'dates': {
                'start': {'dateTime': '2026-02-10T20:00:00Z'},
              },
              'images': [
                {'url': 'http://test.com/image.jpg'},
              ],
            },
          ],
        },
        'page': {'totalElements': 1},
      };

      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(json.encode(jsonResponse), 200));

      final result = await service.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(result.length, 1);
      expect(result[0].name, 'Test Concert');
    });

    test('getConcerts returns empty list on 404 Error', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final result = await service.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(result, isEmpty);
    });

    test('getConcerts returns empty list on 500 Server Error', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

      final result = await service.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(result, isEmpty);
    });

    test('getConcerts handles empty response', () async {
      final emptyResponse = {
        '_embedded': {'events': []},
        'page': {'totalElements': 0},
      };

      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(json.encode(emptyResponse), 200));

      final result = await service.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(result, isEmpty);
    });

    test('getConcerts handles malformed JSON', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('malformed json{', 200));

      final result = await service.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(result, isEmpty);
    });

    test('getConcerts handles missing _embedded field', () async {
      final responseWithoutEmbedded = {
        'page': {'totalElements': 0},
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(json.encode(responseWithoutEmbedded), 200),
      );

      final result = await service.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(result, isEmpty);
    });
  });
}
