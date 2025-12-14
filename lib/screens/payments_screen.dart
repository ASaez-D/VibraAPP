import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Colores base dinámicos
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final actionColor = Colors.redAccent; // Se mantiene, ya que es un color funcional

    return Scaffold(
      // ELIMINADO: backgroundColor: const Color(0xFF0E0E0E)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      appBar: AppBar(
        // ELIMINADO: Colors.transparent
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Pagos",
          style: TextStyle(
            // ELIMINADO: Colors.white
            color: mainTextColor,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gestiona tus métodos de pago",
              // ELIMINADO: Colors.white70
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Pasamos 'isDark' a la función auxiliar
            _buildPaymentOption("Tarjeta de crédito", Icons.credit_card, isDark),
            _buildPaymentOption("PayPal", Icons.account_balance_wallet, isDark),
            _buildPaymentOption("Apple Pay", Icons.phone_iphone, isDark),
            _buildPaymentOption("Google Pay", Icons.android, isDark),

            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Volver",
                  style: TextStyle(
                      color: actionColor, // Rojo funcional se mantiene
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Se añade 'isDark' como argumento
  Widget _buildPaymentOption(String title, IconData icon, bool isDark) {
    
    // Colores del Tile (tarjeta) dinámicos
    final tileColor = isDark ? const Color(0xFF1B1A1A) : Colors.grey[100]; // Gris oscuro vs Gris claro
    final tileIconColor = isDark ? Colors.white70 : Colors.black54;
    final tileTextColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          // ELIMINADO: const Color(0xFF1B1A1A)
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ELIMINADO: Colors.white70
            Icon(icon, color: tileIconColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    // ELIMINADO: Colors.white
                    color: tileTextColor, 
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}