import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/models/ticket.dart';

void main() {
  group('Ticket Model Tests', () {
    test('should create a valid Ticket instance', () {
      final ticket = Ticket(
        eventName: 'Rock Concert',
        eventDate: DateTime(2026, 6, 15, 20, 0),
        location: 'Madrid Arena',
        status: 'confirmed',
      );

      expect(ticket.eventName, 'Rock Concert');
      expect(ticket.eventDate, DateTime(2026, 6, 15, 20, 0));
      expect(ticket.location, 'Madrid Arena');
      expect(ticket.status, 'confirmed');
    });

    test('should create Ticket with all required fields', () {
      final ticket = Ticket(
        eventName: 'Jazz Night',
        eventDate: DateTime(2026, 7, 1, 21, 30),
        location: 'Blue Note',
        status: 'pending',
      );

      expect(ticket.eventName, isNotEmpty);
      expect(ticket.eventDate, isA<DateTime>());
      expect(ticket.location, isNotEmpty);
      expect(ticket.status, isNotEmpty);
    });

    test('should handle different status values', () {
      final statuses = ['confirmed', 'pending', 'cancelled', 'used'];

      for (final status in statuses) {
        final ticket = Ticket(
          eventName: 'Event',
          eventDate: DateTime.now(),
          location: 'Location',
          status: status,
        );

        expect(ticket.status, status);
      }
    });

    test('should handle past and future dates', () {
      final pastTicket = Ticket(
        eventName: 'Past Event',
        eventDate: DateTime(2020, 1, 1),
        location: 'Venue',
        status: 'used',
      );

      final futureTicket = Ticket(
        eventName: 'Future Event',
        eventDate: DateTime(2030, 12, 31),
        location: 'Venue',
        status: 'confirmed',
      );

      expect(pastTicket.eventDate.isBefore(DateTime.now()), true);
      expect(futureTicket.eventDate.isAfter(DateTime.now()), true);
    });
  });
}
