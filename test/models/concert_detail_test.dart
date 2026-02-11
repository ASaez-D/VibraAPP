import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/models/concert_detail.dart';

void main() {
  group('ConcertDetail Model Tests', () {
    test('fromJson should create a valid ConcertDetail with all fields', () {
      final json = {
        'name': 'Taylor Swift - Eras Tour',
        '_embedded': {
          'venues': [
            {
              'name': 'Santiago Bernabéu',
              'address': {'line1': 'Av. de Concha Espina, 1'},
              'city': {'name': 'Madrid'},
              'country': {'name': 'España'},
              'location': {'latitude': '40.453054', 'longitude': '-3.688344'},
            },
          ],
        },
        'dates': {
          'start': {'dateTime': '2026-06-15T20:00:00Z'},
        },
        'images': [
          {'url': 'https://example.com/low.jpg', 'width': 200},
          {'url': 'https://example.com/high.jpg', 'width': 1024},
          {'url': 'https://example.com/medium.jpg', 'width': 500},
        ],
        'classifications': [
          {
            'genre': {'name': 'Pop'},
          },
        ],
        'priceRanges': [
          {'min': 50.0, 'max': 150.0, 'currency': 'EUR'},
        ],
        'url': 'https://ticketmaster.com/event/123',
      };

      final concertDetail = ConcertDetail.fromJson(json);

      expect(concertDetail.name, 'Taylor Swift - Eras Tour');
      expect(concertDetail.venue, 'Santiago Bernabéu');
      expect(concertDetail.address, 'Av. de Concha Espina, 1');
      expect(concertDetail.city, 'Madrid');
      expect(concertDetail.country, 'España');
      expect(
        concertDetail.date,
        DateTime.parse('2026-06-15T20:00:00Z').toLocal(),
      );
      expect(
        concertDetail.imageUrl,
        'https://example.com/high.jpg',
      ); // High quality image
      expect(concertDetail.ticketUrl, 'https://ticketmaster.com/event/123');
      expect(concertDetail.genre, 'Pop');
      expect(concertDetail.priceRange, 'Desde 50 €');
      expect(concertDetail.latitude, 40.453054);
      expect(concertDetail.longitude, -3.688344);
    });

    test('fromJson should handle missing venue data with defaults', () {
      final json = {
        'name': 'Mystery Concert',
        'dates': {
          'start': {'dateTime': '2026-07-01T19:00:00Z'},
        },
      };

      final concertDetail = ConcertDetail.fromJson(json);

      expect(concertDetail.name, 'Mystery Concert');
      expect(concertDetail.venue, 'Desconocido');
      expect(concertDetail.address, '');
      expect(concertDetail.city, '');
      expect(concertDetail.country, '');
      expect(concertDetail.latitude, null);
      expect(concertDetail.longitude, null);
    });

    test('fromJson should select high quality image (>600px)', () {
      final json = {
        'name': 'Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        'images': [
          {'url': 'https://example.com/small.jpg', 'width': 100},
          {'url': 'https://example.com/medium.jpg', 'width': 400},
          {'url': 'https://example.com/large.jpg', 'width': 800},
        ],
      };

      final concertDetail = ConcertDetail.fromJson(json);
      expect(concertDetail.imageUrl, 'https://example.com/large.jpg');
    });

    test('fromJson should handle price ranges correctly', () {
      // Test free event
      final freeJson = {
        'name': 'Free Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        'priceRanges': [
          {'min': 0.0, 'currency': 'EUR'},
        ],
      };

      final freeConcert = ConcertDetail.fromJson(freeJson);
      expect(freeConcert.priceRange, 'GRATIS');

      // Test fixed price
      final fixedJson = {
        'name': 'Fixed Price Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        'priceRanges': [
          {'min': 30.0, 'max': 30.0, 'currency': 'EUR'},
        ],
      };

      final fixedConcert = ConcertDetail.fromJson(fixedJson);
      expect(fixedConcert.priceRange, '30 €');

      // Test price range
      final rangeJson = {
        'name': 'Range Price Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        'priceRanges': [
          {'min': 25.5, 'max': 100.0, 'currency': 'EUR'},
        ],
      };

      final rangeConcert = ConcertDetail.fromJson(rangeJson);
      expect(rangeConcert.priceRange, 'Desde 25.5 €');
    });

    test('fromJson should handle different currencies', () {
      // Test USD
      final usdJson = {
        'name': 'US Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        'priceRanges': [
          {'min': 50.0, 'currency': 'USD'},
        ],
      };

      final usdConcert = ConcertDetail.fromJson(usdJson);
      expect(usdConcert.priceRange, 'Desde 50 \$');

      // Test GBP
      final gbpJson = {
        'name': 'UK Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        'priceRanges': [
          {'min': 40.0, 'currency': 'GBP'},
        ],
      };

      final gbpConcert = ConcertDetail.fromJson(gbpJson);
      expect(gbpConcert.priceRange, 'Desde 40 £');
    });

    test('fromJson should use default value when price data is missing', () {
      final json = {
        'name': 'Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
      };

      final concertDetail = ConcertDetail.fromJson(json);
      expect(concertDetail.priceRange, 'Ver precios');
    });

    test('fromJson should handle null and empty JSON gracefully', () {
      final json = <String, dynamic>{};

      final concertDetail = ConcertDetail.fromJson(json);

      expect(concertDetail.name, 'Evento sin nombre');
      expect(concertDetail.venue, 'Desconocido');
      expect(concertDetail.imageUrl, '');
      expect(concertDetail.ticketUrl, '');
      expect(concertDetail.genre, '');
      expect(concertDetail.priceRange, 'Ver precios');
    });

    test('fromJson should parse location coordinates correctly', () {
      final json = {
        'name': 'Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        '_embedded': {
          'venues': [
            {
              'name': 'Venue',
              'location': {'latitude': '40.416775', 'longitude': '-3.703790'},
            },
          ],
        },
      };

      final concertDetail = ConcertDetail.fromJson(json);
      expect(concertDetail.latitude, 40.416775);
      expect(concertDetail.longitude, -3.70379);
    });

    test('fromJson should handle invalid location data', () {
      final json = {
        'name': 'Concert',
        'dates': {
          'start': {'dateTime': '2026-06-01T20:00:00Z'},
        },
        '_embedded': {
          'venues': [
            {
              'name': 'Venue',
              'location': {'latitude': 'invalid', 'longitude': 'invalid'},
            },
          ],
        },
      };

      final concertDetail = ConcertDetail.fromJson(json);
      expect(concertDetail.latitude, null);
      expect(concertDetail.longitude, null);
    });
  });
}
