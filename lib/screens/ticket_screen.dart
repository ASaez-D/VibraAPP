import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Ticket {
  final String eventName;
  final DateTime eventDate;
  final String location;
  final String status; // "Activa", "Usada", "Cancelada"

  Ticket({
    required this.eventName,
    required this.eventDate,
    required this.location,
    required this.status,
  });
}

class TicketScreen extends StatelessWidget {
  final List<Ticket> tickets;

  const TicketScreen({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E1A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Mis Entradas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: tickets.isEmpty
          ? const Center(
              child: Text(
                "No tienes entradas disponibles.",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketCard(ticket);
              },
            ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    Color statusColor;
    switch (ticket.status) {
      case "Activa":
        statusColor = Colors.purpleAccent;
        break;
      case "Usada":
        statusColor = Colors.grey;
        break;
      case "Cancelada":
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.white;
    }

    // Mismo morado oscuro que SocialScreen
    const Color darkPurple = Color(0xFF0A0013);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Sin degradado, color sólido
        color: ticket.status == "Activa" ? darkPurple : const Color(0xFF1B1B2A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade900.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket.eventName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${DateFormat('d MMMM yyyy', 'es_ES').format(ticket.eventDate)}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.location,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                ticket.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


