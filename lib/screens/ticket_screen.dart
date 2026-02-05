import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_constants.dart';

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
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Mis Entradas",
          style: TextStyle(
            color: primaryTextColor,
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
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketCard(context, ticket);
              },
            ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Ticket ticket) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF1C1C1C) : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    final shadowColor = isDarkMode
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
        statusColor = primaryTextColor;
    }

    final statusTextColor =
        (ticket.status == "Activa" || ticket.status == "Usada")
        ? Colors.black
        : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
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
              color: primaryTextColor,
              fontSize: AppTypography.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            // Corregido: Eliminada la interpolación innecesaria '${...}'
            DateFormat('d MMMM yyyy', 'es_ES').format(ticket.eventDate),
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: AppTypography.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            ticket.location,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: AppTypography.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(AppBorders.radiusLarge),
              ),
              child: Text(
                ticket.status.toUpperCase(),
                style: TextStyle(
                  color: statusTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
