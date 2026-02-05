/// Widget de tarjeta con tema consistente
library;

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

/// Tarjeta con estilo consistente que se adapta al tema
class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final VoidCallback? onTap;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(context);

    final card = Container(
      padding: padding ?? AppLayout.paddingCardAll,
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppBorders.radiusExtraLarge,
        ),
        border: Border.all(color: theme.borderColor),
        boxShadow: theme.cardShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}
