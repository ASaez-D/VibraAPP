import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class TickerScreen extends StatelessWidget {
  final List<Ticket> tickets;

  const TickerScreen({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, 
        title: Text(
          "Mis Entradas",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: tickets.isEmpty
          ? Center(
              child: Text(
                "No tienes entradas disponibles.",
                style: TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketCard(context, ticket);
              },
            ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Ticket ticket) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C1C1C) : Colors.white; 
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    // --- CAMBIO AQUÍ: Uso de withValues en lugar de withOpacity ---
    final shadowColor = isDark 
        ? Colors.greenAccent.withValues(alpha: 0.2) 
        : Colors.black.withValues(alpha: 0.1); 
    
    Color statusColor;
    switch (ticket.status) {
      case "Activa":
        statusColor = Colors.greenAccent;
        break;
      case "Usada":
        statusColor = Colors.grey;
        break;
      case "Cancelada":
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = mainTextColor;
    }
    
    final statusTextColor = (ticket.status == "Activa" || ticket.status == "Usada") 
        ? Colors.black 
        : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
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
            style: TextStyle(
              color: mainTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            // Corregido: Eliminada la interpolación innecesaria '${...}'
            DateFormat('d MMMM yyyy', 'es_ES').format(ticket.eventDate),
            style: TextStyle(color: subtitleColor, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.location,
            style: TextStyle(color: subtitleColor, fontSize: 14),
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
                style: TextStyle(
                  color: statusTextColor,
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