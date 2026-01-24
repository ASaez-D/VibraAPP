import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // <--- Importante para las traducciones

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
    'ES': ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao', 'Málaga', 'Zaragoza'],
    'US': ['New York', 'Los Angeles', 'Chicago', 'Miami', 'Las Vegas', 'Austin', 'San Francisco'],
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
  void _showCitySelectionDialog(BuildContext context, Map<String, String> country) {
    final l10n = AppLocalizations.of(context)!; // Acceso a traducciones
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = Colors.greenAccent;
    final List<String> cities = _popularCities[country['code']] ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
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
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 20),
                      Text(country['flag']!, style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 10),
                      // TRADUCCIÓN: Explora {pais}
                      Text(l10n.regionExplore(country['name']!), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
                      // TRADUCCIÓN: ¿Buscas en una ciudad?
                      Text(l10n.regionDialogCityBody, style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey, fontSize: 14), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Divider(color: isDarkMode ? Colors.white10 : Colors.grey.shade200, height: 1),
                
                // Lista de Opciones
                Expanded(
                  child: ListView(
                    controller: controller,
                    children: [
                      // OPCIÓN 1: TODO EL PAÍS
                      ListTile(
                        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: accentColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.public, color: accentColor)),
                        // TRADUCCIÓN: Todo el país
                        title: Text(l10n.regionOptionWholeCountry, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                        // TRADUCCIÓN: Ver todo en {pais}
                        subtitle: Text(l10n.regionOptionWholeCountrySub(country['name']!), style: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey, fontSize: 12)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context, {'code': country['code'], 'city': null});
                        },
                      ),
                      
                      if (cities.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          // TRADUCCIÓN: Ciudades Populares
                          child: Text(l10n.regionHeaderPopular, style: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ),
                        // LISTA DE CIUDADES
                        ...cities.map((city) => ListTile(
                          leading: const Icon(Icons.location_city, size: 20),
                          title: Text(city, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                          trailing: const Icon(Icons.chevron_right, size: 16),
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context, {'code': country['code'], 'city': city});
                          },
                        )),
                      ],

                      // OPCIÓN MANUAL
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        // TRADUCCIÓN: Otra ubicación
                        child: Text(l10n.regionHeaderOther, style: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit, size: 20),
                        // TRADUCCIÓN: Escribir otra ciudad...
                        title: Text(l10n.regionOptionManual, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
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
          }
        );
      },
    );
  }

  // DIÁLOGO PARA ESCRIBIR MANUALMENTE
  void _showManualCityInput(BuildContext context, Map<String, String> country) {
    final l10n = AppLocalizations.of(context)!; // Acceso a traducciones
    final TextEditingController manualController = TextEditingController();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Colors.greenAccent;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        // TRADUCCIÓN: Título diálogo manual
        title: Text(l10n.regionManualTitle, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: TextField(
          controller: manualController,
          autofocus: true,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          cursorColor: accentColor,
          decoration: InputDecoration(
            // TRADUCCIÓN: Hint (Ej: Benidorm)
            hintText: l10n.regionManualHint,
            hintStyle: TextStyle(color: isDarkMode ? Colors.white30 : Colors.grey),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentColor)),
          ),
        ),
        actions: [
          // TRADUCCIÓN: Cancelar
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.dialogCancel, style: const TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, {
                'code': country['code'],
                'city': manualController.text.trim().isNotEmpty ? manualController.text.trim() : null
              });
            },
            // TRADUCCIÓN: Buscar
            child: Text(l10n.regionManualSearch, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Acceso a traducciones
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7);
    final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);
    final Color searchBarBg = isDarkMode ? const Color(0xFF1C1C1E) : Colors.grey.shade200;
    final Color accentColor = Colors.greenAccent;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        // TRADUCCIÓN: Título principal
        title: Text(l10n.regionTitle, style: TextStyle(color: primaryText, fontWeight: FontWeight.w700, fontSize: 18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: searchBarBg, borderRadius: BorderRadius.circular(16)),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: primaryText),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  // TRADUCCIÓN: Hint búsqueda
                  hintText: l10n.regionSearchHint,
                  hintStyle: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey),
                  prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white38 : Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: Icon(Icons.close, size: 20, color: isDarkMode ? Colors.white54 : Colors.black54), onPressed: _searchController.clear) : null
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredCountries.length,
              separatorBuilder: (_, __) => Divider(color: isDarkMode ? Colors.white10 : Colors.grey.shade300, height: 1),
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country['code'] == widget.currentCountryCode;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  leading: Container(
                    width: 50, height: 50, alignment: Alignment.center,
                    decoration: BoxDecoration(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                    child: Text(country['flag']!, style: const TextStyle(fontSize: 28)),
                  ),
                  title: Text(country['name']!, style: TextStyle(color: primaryText, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, fontSize: 16)),
                  trailing: isSelected 
                    ? Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: accentColor.withOpacity(0.2), shape: BoxShape.circle), child: Icon(Icons.check, color: accentColor, size: 16))
                    : Icon(Icons.chevron_right_rounded, color: isDarkMode ? Colors.white24 : Colors.black26),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  tileColor: isSelected ? accentColor.withOpacity(0.05) : Colors.transparent,
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
