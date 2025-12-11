import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart'; // No es necesario importar si ya lo haces en main.dart

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
      // ELIMINADO: const Color(0xFF0E0E0E)
      // Ahora usa el color de fondo definido en main.dart (blanco o negro)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      
      appBar: AppBar(
        // ELIMINADO: Colors.black
        // Ahora usa el color de la AppBar definido en main.dart
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, 
        
        title: Text(
          "Mis Entradas",
          style: TextStyle(
            // ELIMINADO: Colors.white
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
                // ELIMINADO: Colors.white54
                style: TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketCard(context, ticket); // Pasamos context
              },
            ),
    );
  }

  // Se añade BuildContext context como argumento para poder usar Theme.of(context)
  Widget _buildTicketCard(BuildContext context, Ticket ticket) {
    // Colores dinámicos específicos para el Card
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C1C1C) : Colors.white; // Color de tarjeta adaptado
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final shadowColor = isDark ? Colors.greenAccent.withOpacity(0.2) : Colors.black12; // Sombra más suave en modo claro
    
    // El color de estado (statusColor) se mantiene igual ya que son colores funcionales (rojo, verde, gris)
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
        statusColor = mainTextColor; // Usa el color de texto principal si no hay estado
    }
    
    // Determinar el color del texto del estado (Debe ser oscuro si el fondo del statusColor es claro)
    final statusTextColor = ticket.status == "Activa" || ticket.status == "Usada" 
        ? Colors.black // Negro sobre verde/gris claro
        : Colors.white; // Blanco sobre rojoAccent (que suele ser oscuro)

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ELIMINADO: const Color(0xFF1C1C1C)
        color: cardColor, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ELIMINADO: Colors.greenAccent.withOpacity(0.2)
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
              // ELIMINADO: Colors.white
              color: mainTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${DateFormat('d MMMM yyyy', 'es_ES').format(ticket.eventDate)}",
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
                  // ELIMINADO: lógica compleja (ticket.status == "Usada" ? Colors.black : Colors.black)
                  color: statusTextColor, // Color dinámico según el estado
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