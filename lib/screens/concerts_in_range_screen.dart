import 'package:flutter/material.dart';

class ConcertsInRangeScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ConcertsInRangeScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Conciertos", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          "Conciertos del ${startDate.day}/${startDate.month} al ${endDate.day}/${endDate.month}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
