import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String displayName;

  const HomeScreen({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibra'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '¡Bienvenido, $displayName!',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
