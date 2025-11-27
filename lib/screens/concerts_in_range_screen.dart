import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/concert.dart';
import '../services/ticketmaster_service.dart';

class ConcertsInRangeScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ConcertsInRangeScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ConcertsInRangeScreen> createState() => _ConcertsInRangeScreenState();
}

class _ConcertsInRangeScreenState extends State<ConcertsInRangeScreen> {
  final service = TicketmasterService();
  late Future<List<Concert>> concertsFuture;

  @override
  void initState() {
    super.initState();
    concertsFuture = service.getConcerts(widget.startDate, widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Conciertos", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Concert>>(
        future: concertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay conciertos',
                    style: TextStyle(color: Colors.white)));
          } else {
            final concerts = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: concerts.length,
              itemBuilder: (context, index) {
                final concert = concerts[index];
                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: concert.imageUrl.isNotEmpty
                        ? Image.network(concert.imageUrl,
                            width: 50, fit: BoxFit.cover)
                        : null,
                    title: Text(concert.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${concert.venue}\n${DateFormat('d MMMM yyyy, HH:mm', 'es_ES').format(concert.date)}',
                        style: const TextStyle(color: Colors.white70)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
