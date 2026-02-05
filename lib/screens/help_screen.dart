import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../utils/app_logger.dart';
import '../utils/text_constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  /// Abre el cliente de correo para contactar con soporte
  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: AppTextConstants.supportEmail,
      query: 'subject=${AppTextConstants.supportEmailSubject}',
    );

    try {
      if (!await launchUrl(emailUri)) {
        throw Exception(AppTextConstants.errorFailedToOpenEmail);
      }
    } catch (error, stackTrace) {
      AppLogger.error('Failed to open email client', error, stackTrace);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No se pudo abrir la aplicación de correo. Escribe a ${AppTextConstants.supportEmail}",
            ),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = AppTheme(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.primaryText,
            size: AppSizes.iconSizeMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.menuHelp,
          style: TextStyle(
            color: theme.primaryText,
            fontSize: AppTypography.fontSizeRegular,
            fontWeight: AppTypography.fontWeightBold,
            letterSpacing: AppTypography.letterSpacingNormal,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            localizations.helpMainSubtitle,
            style: TextStyle(
              color: theme.primaryText,
              fontSize: AppTypography.fontSizeTitle,
              fontWeight: AppTypography.fontWeightBlack,
              height: 1.1,
              letterSpacing: AppTypography.letterSpacingTight,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          Text(
            localizations.helpSectionFaq.toUpperCase(),
            style: TextStyle(
              color: theme.secondaryText,
              fontSize: AppTypography.fontSizeSmall,
              fontWeight: AppTypography.fontWeightBold,
              letterSpacing: AppTypography.letterSpacingExtraWide,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            decoration: BoxDecoration(
              color: theme.cardBackground,
              borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
              border: Border.all(color: theme.borderColor),
            ),
            child: Column(
              children: [
                _FaqTile(
                  question: localizations.helpFaq1Q,
                  answer: localizations.helpFaq1A,
                  textColor: theme.primaryText,
                  subTextColor: theme.secondaryText,
                ),
                Divider(height: 1, color: theme.dividerColor),
                _FaqTile(
                  question: localizations.helpFaq2Q,
                  answer: localizations.helpFaq2A,
                  textColor: theme.primaryText,
                  subTextColor: theme.secondaryText,
                ),
                Divider(height: 1, color: theme.dividerColor),
                _FaqTile(
                  question: localizations.helpFaq3Q,
                  answer: localizations.helpFaq3A,
                  textColor: theme.primaryText,
                  subTextColor: theme.secondaryText,
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          Text(
            localizations.helpSectionSupport.toUpperCase(),
            style: TextStyle(
              color: theme.secondaryText,
              fontSize: AppTypography.fontSizeSmall,
              fontWeight: AppTypography.fontWeightBold,
              letterSpacing: AppTypography.letterSpacingExtraWide,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _SupportButton(
            icon: Icons.email_outlined,
            title: localizations.helpSupportContact,
            subtitle: AppTextConstants.supportEmail,
            accentColor: theme.accentColor,
            cardColor: theme.cardBackground,
            textColor: theme.primaryText,
            onTap: () => _sendEmail(context),
          ),
          const SizedBox(height: AppSpacing.md),
          _SupportButton(
            icon: Icons.bug_report_outlined,
            title: localizations.helpSupportReport,
            subtitle: "Reportar error técnico",
            accentColor: AppColors.warningColor,
            cardColor: theme.cardBackground,
            textColor: theme.primaryText,
            onTap: () => _sendEmail(context),
          ),

          const SizedBox(height: AppSpacing.huge),
          Center(
            child: Text(
              "${AppTextConstants.appName} v${AppTextConstants.appVersion}",
              style: TextStyle(
                color: theme.secondaryText.withValues(
                  alpha: AppColors.opacityVeryHigh,
                ),
                fontSize: AppTypography.fontSizeSmall,
                fontWeight: AppTypography.fontWeightSemiBold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGETS AUXILIARES
// -----------------------------------------------------------------------------

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final Color textColor;
  final Color subTextColor;
  final bool isLast;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.textColor,
    required this.subTextColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xs,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        iconColor: textColor,
        collapsedIconColor: subTextColor,
        title: Text(
          question,
          style: TextStyle(
            color: textColor,
            fontWeight: AppTypography.fontWeightSemiBold,
            fontSize: AppTypography.fontSizeMedium + 1,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: subTextColor,
              fontSize: AppTypography.fontSizeMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  const _SupportButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
          border: Border.all(
            color: textColor.withValues(alpha: AppColors.opacityLow),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: AppColors.opacityMedium),
                borderRadius: BorderRadius.circular(AppBorders.radiusMedium),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: AppSizes.iconSizeLarge,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.5),
                      fontSize: AppTypography.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: textColor.withValues(alpha: AppColors.opacityVeryHigh),
              size: AppSizes.iconSizeSmall + 2,
            ),
          ],
        ),
      ),
    );
  }
}
