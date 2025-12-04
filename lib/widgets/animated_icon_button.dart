import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para HapticFeedback

class AnimatedIconButton extends StatefulWidget {
  final bool isSelected;
  final IconData iconSelected;
  final IconData iconUnselected;
  final Color colorSelected;
  final VoidCallback onTap;
  // Opcional: color de fondo cuando está seleccionado
  final Color? fillColorSelected; 

  const AnimatedIconButton({
    super.key,
    required this.isSelected,
    required this.iconSelected,
    required this.iconUnselected,
    required this.colorSelected,
    required this.onTap,
    this.fillColorSelected,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

// Usamos SingleTickerProviderStateMixin para la animación
class _AnimatedIconButtonState extends State<AnimatedIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Configuración de la animación: rápida y con rebote
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150), // Duración corta para que se sienta ágil
      vsync: this,
    );

    // La escala va de 1.0 (tamaño normal) a 1.3 (un 30% más grande) y vuelve.
    // Curves.easeOutBack da ese efecto de "rebote" elástico al final.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // 1. Feedback táctil (Vibración sutil) ¡IMPORTANTE PARA SENSACIÓN PREMIUM!
    HapticFeedback.lightImpact();

    // 2. Ejecutar la lógica principal (cambiar estado en la app)
    widget.onTap();

    // 3. Ejecutar la animación: ir hacia adelante y luego volver atrás
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el mismo diseño de contenedor que tenías antes
    final Color currentColor = widget.isSelected ? widget.colorSelected : Colors.white;
    final Color currentFill = widget.isSelected 
        ? (widget.fillColorSelected ?? widget.colorSelected.withOpacity(0.2))
        : Colors.white.withOpacity(0.15);

    return GestureDetector(
      onTap: _handleTap,
      // ScaleTransition envuelve tu botón y aplica la animación de tamaño
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentFill,
            border: Border.all(
              color: currentColor.withOpacity(widget.isSelected ? 1.0 : 0.5),
              width: 1
            ),
          ),
          child: Icon(
            widget.isSelected ? widget.iconSelected : widget.iconUnselected,
            color: currentColor,
            size: 18,
          ),
        ),
      ),
    );
  }
}