import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/models/concert.dart';

void main() {
  group('Concert Model Tests', () {
    test('fromJson should create a valid Concert object', () {
      final json = {
        'name': 'Rock in Rio',
        '_embedded': {
          'venues': [
            {'name': 'Arganda del Rey'},
          ],
        },
        'dates': {
          'start': {'dateTime': '2026-06-20T20:00:00Z'},
        },
        'images': [
          {'url': 'https://example.com/image.jpg'},
        ],
      };

      final concert = Concert.fromJson(json);

      expect(concert.name, 'Rock in Rio');
      expect(concert.venue, 'Arganda del Rey');
      expect(concert.date, DateTime.parse('2026-06-20T20:00:00Z'));
      expect(concert.imageUrl, 'https://example.com/image.jpg');
    });

    test('fromJson should handle missing fields with default values', () {
      final json = <String, dynamic>{};

      final concert = Concert.fromJson(json);

      expect(concert.name, 'Sin nombre');
      expect(concert.venue, 'Desconocido');
      expect(concert.imageUrl, '');
      // Date should be roughly now
      expect(
        concert.date.isBefore(DateTime.now().add(const Duration(seconds: 1))),
        true,
      );
    });

    test('fromJson should handle nulls gracefully', () {
      final json = {
        'name': null,
        '_embedded': null,
        'dates': null,
        'images': null,
      };

      final concert = Concert.fromJson(json as Map<String, dynamic>);

      expect(concert.name, 'Sin nombre');
      expect(concert.venue, 'Desconocido');
      expect(concert.imageUrl, '');
    });
  });
}
