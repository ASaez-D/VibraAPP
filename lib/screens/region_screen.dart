import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';

class RegionScreen extends StatefulWidget {
  final String currentCountryCode;

  const RegionScreen({super.key, required this.currentCountryCode});

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  final TextEditingController _searchController = TextEditingController();

  // NOTA: Los nombres de los países se mantienen estáticos (o en su idioma nativo)
  // para no complicar la lógica de traducción de nombres propios.
  final List<Map<String, String>> _allCountries = [
    {'code': 'ES', 'name': 'España', 'flag': '🇪🇸'},
    {'code': 'US', 'name': 'United States', 'flag': '🇺🇸'},
    {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'code': 'FR', 'name': 'France', 'flag': '🇫🇷'},
    {'code': 'DE', 'name': 'Deutschland', 'flag': '🇩🇪'},
    {'code': 'IT', 'name': 'Italia', 'flag': '🇮🇹'},
    {'code': 'PT', 'name': 'Portugal', 'flag': '🇵🇹'},
    {'code': 'MX', 'name': 'México', 'flag': '🇲🇽'},
    {'code': 'CA', 'name': 'Canada', 'flag': '🇨🇦'},
    {'code': 'AR', 'name': 'Argentina', 'flag': '🇦🇷'},
    {'code': 'CO', 'name': 'Colombia', 'flag': '🇨🇴'},
    {'code': 'CL', 'name': 'Chile', 'flag': '🇨🇱'},
    {'code': 'NL', 'name': 'Nederland', 'flag': '🇳🇱'},
    {'code': 'BE', 'name': 'Belgique', 'flag': '🇧🇪'},
    {'code': 'SE', 'name': 'Sverige', 'flag': '🇸🇪'},
  ];

  final Map<String, List<String>> _popularCities = {
    'ES': [
      'Madrid',
      'Barcelona',
      'Valencia',
      'Sevilla',
      'Bilbao',
      'Málaga',
      'Zaragoza',
    ],
    'US': [
      'New York',
      'Los Angeles',
      'Chicago',
      'Miami',
      'Las Vegas',
      'Austin',
      'San Francisco',
    ],
    'GB': ['London', 'Manchester', 'Glasgow', 'Birmingham', 'Liverpool'],
    'FR': ['Paris', 'Lyon', 'Marseille', 'Bordeaux', 'Nice'],
    'DE': ['Berlin', 'Munich', 'Hamburg', 'Cologne', 'Frankfurt'],
    'IT': ['Rome', 'Milan', 'Florence', 'Naples', 'Turin'],
    'PT': ['Lisbon', 'Porto', 'Braga'],
    'MX': ['Mexico City', 'Monterrey', 'Guadalajara'],
    'CA': ['Toronto', 'Montreal', 'Vancouver'],
    'AR': ['Buenos Aires', 'Cordoba', 'Rosario'],
    'CO': ['Bogota', 'Medellin', 'Cali'],
    'CL': ['Santiago'],
    'NL': ['Amsterdam', 'Rotterdam'],
    'BE': ['Brussels', 'Antwerp'],
    'SE': ['Stockholm', 'Gothenburg'],
  };

  List<Map<String, String>> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = _allCountries;
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = _allCountries;
      } else {
        _filteredCountries = _allCountries
            .where((country) => country['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // DIÁLOGO DE SELECCIÓN DE CIUDAD
  void _showCitySelectionDialog(
    BuildContext context,
    Map<String, String> country,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);
    final List<String> cities = _popularCities[country['code']] ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                // Cabecera del Modal
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha : 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // TRADUCCIÓN: Explora {pais}
                      Text(
                        l10n.regionExplore(country['name']!),
                        style: TextStyle(
                          color: theme.primaryText,
                          fontWeight: AppTypography.fontWeightBold,
                          fontSize: 22,
                        ),
                      ),
                      // TRADUCCIÓN: ¿Buscas en una ciudad?
                      Text(
                        l10n.regionDialogCityBody,
                        style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: AppTypography.fontSizeRegular,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(color: theme.borderColor, height: 1),

                // Lista de Opciones
                Expanded(
                  child: ListView(
                    controller: controller,
                    children: [
                      // OPCIÓN 1:TODO EL PAÍS
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.public,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        // TRADUCCIÓN: Todo el país
                        title: Text(
                          l10n.regionOptionWholeCountry,
                          style: TextStyle(
                            color: theme.primaryText,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                        // TRADUCCIÓN: Ver todo en {pais}
                        subtitle: Text(
                          l10n.regionOptionWholeCountrySub(country['name']!),
                          style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: AppTypography.fontSizeSmall,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context, {
                            'code': country['code'],
                            'city': null,
                          });
                        },
                      ),

                      if (cities.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          // TRADUCCIÓN: Ciudades Populares
                          child: Text(
                            l10n.regionHeaderPopular,
                            style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: AppTypography.fontSizeSmall,
                              fontWeight: AppTypography.fontWeightBold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        // LISTA DE CIUDADES
                        ...cities.map(
                          (city) => ListTile(
                            leading: const Icon(
                              Icons.location_city,
                              size: AppSizes.iconSizeMedium,
                            ),
                            title: Text(
                              city,
                              style: TextStyle(color: theme.primaryText),
                            ),
                            trailing: const Icon(Icons.chevron_right, size: 16),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.pop(context, {
                                'code': country['code'],
                                'city': city,
                              });
                            },
                          ),
                        ),
                      ],

                      // OPCIÓN MANUAL
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        // TRADUCCIÓN: Otra ubicación
                        child: Text(
                          l10n.regionHeaderOther,
                          style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: AppTypography.fontSizeSmall,
                            fontWeight: AppTypography.fontWeightBold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.edit,
                          size: AppSizes.iconSizeMedium,
                        ),
                        // TRADUCCIÓN: Escribir otra ciudad...
                        title: Text(
                          l10n.regionOptionManual,
                          style: TextStyle(color: theme.primaryText),
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          _showManualCityInput(context, country);
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // DIÁLOGO PARA ESCRIBIR MANUALMENTE
  void _showManualCityInput(BuildContext context, Map<String, String> country) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);
    final TextEditingController manualController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardBackground,
        // TRADUCCIÓN: Título diálogo manual
        title: Text(
          l10n.regionManualTitle,
          style: TextStyle(color: theme.primaryText),
        ),
        content: TextField(
          controller: manualController,
          autofocus: true,
          style: TextStyle(color: theme.primaryText),
          cursorColor: AppColors.primaryAccent,
          decoration: InputDecoration(
            // TRADUCCIÓN: Hint (Ej: Benidorm)
            hintText: l10n.regionManualHint,
            hintStyle: TextStyle(color: theme.secondaryText),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryAccent),
            ),
          ),
        ),
        actions: [
          // TRADUCCIÓN: Cancelar
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.dialogCancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, {
                'code': country['code'],
                'city': manualController.text.trim().isNotEmpty
                    ? manualController.text.trim()
                    : null,
              });
            },
            // TRADUCCIÓN: Buscar
            child: Text(
              l10n.regionManualSearch,
              style: const TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: AppTypography.fontWeightBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.primaryText,
            size: AppSizes.iconSizeMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        // TRADUCCIÓN: Título principal
        title: Text(
          l10n.regionTitle,
          style: TextStyle(
            color: theme.primaryText,
            fontWeight: AppTypography.fontWeightBold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: theme.cardBackground,
                borderRadius: BorderRadius.circular(AppBorders.radiusLarge),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.primaryText),
                cursorColor: AppColors.primaryAccent,
                decoration: InputDecoration(
                  // TRADUCCIÓN: Hint búsqueda
                  hintText: l10n.regionSearchHint,
                  hintStyle: TextStyle(color: theme.secondaryText),
                  prefixIcon: Icon(Icons.search, color: theme.secondaryText),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            size: AppSizes.iconSizeMedium,
                            color: theme.secondaryText,
                          ),
                          onPressed: _searchController.clear,
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              itemCount: _filteredCountries.length,
              separatorBuilder: (_, __) =>
                  Divider(color: theme.borderColor, height: 1),
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country['code'] == widget.currentCountryCode;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppBorders.radiusMedium,
                      ),
                    ),
                    child: Text(
                      country['flag']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  title: Text(
                    country['name']!,
                    style: TextStyle(
                      color: theme.primaryText,
                      fontWeight: isSelected
                          ? AppTypography.fontWeightBlack
                          : AppTypography.fontWeightRegular,
                      fontSize: AppTypography.fontSizeRegular,
                    ),
                  ),
                  trailing: isSelected
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.primaryAccent,
                            size: AppSizes.iconSizeSmall,
                          ),
                        )
                      : Icon(
                          Icons.chevron_right_rounded,
                          color: theme.secondaryText,
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorders.radiusLarge),
                  ),
                  tileColor: isSelected
                      ? AppColors.primaryAccent.withValues(alpha: 0.05)
                      : Colors.transparent,
                  onTap: () => _showCitySelectionDialog(context, country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
