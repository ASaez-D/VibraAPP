import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';

import '../models/ticket.dart';

class TicketScreen extends StatelessWidget {
  final List<Ticket> tickets;

  const TicketScreen({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.ticketScreenTitle,
          style: TextStyle(
            color: theme.primaryText,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 80,
              color: theme.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.inDevelopment,
              style: TextStyle(
                color: theme.secondaryText,
                fontSize: AppTypography.fontSizeLarge,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
