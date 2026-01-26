import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import 'concerts_in_range_screen.dart';

class CalendarScreen extends StatefulWidget {
  final String countryCode;
  final String? city;

  const CalendarScreen({
    super.key,
    this.countryCode = 'ES', // Valor por defecto si no llega nada
    this.city,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String activeQuickButton = '';
  bool isQuickSelection = false;

  final DateTime currentDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NEGOCIO ---

  void _onDateTap(DateTime date) {
    HapticFeedback.lightImpact();
    setState(() {
      if (isQuickSelection) {
        isQuickSelection = false;
        activeQuickButton = '';
      }

      if (startDate != null && endDate == null && !date.isBefore(startDate!)) {
        endDate = date;
      } else {
        startDate = date;
        endDate = null;
      }
      activeQuickButton = '';
    });
  }

  void _onQuickSelect(String label, DateTime? date, {bool rangeWeek = false, bool rangeNext30Days = false}) {
    HapticFeedback.lightImpact();
    setState(() {
      activeQuickButton = label;
      isQuickSelection = true;
      
      if (rangeWeek) {
        startDate = DateTime.now();
        endDate = DateTime.now().add(const Duration(days: 6));
      } else if (rangeNext30Days) {
        startDate = DateTime.now();
        endDate = DateTime.now().add(const Duration(days: 30));
      } else if (date != null) {
        startDate = date;
        endDate = date;
      }
    });
  }

  // --- BUILD PRINCIPAL ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = _CalendarTheme(Theme.of(context));
    // Generamos 12 meses a futuro
    final monthsList = List.generate(12, (i) => DateTime(currentDate.year, currentDate.month + i));

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(l10n, theme),
            _buildCalendarList(monthsList, theme),
            _buildConfirmButton(l10n, theme),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES DE UI ---

  Widget _buildHeader(AppLocalizations l10n, _CalendarTheme theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      color: theme.headerBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryText, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.calendarTitle, style: TextStyle(color: theme.primaryText, fontWeight: FontWeight.bold, fontSize: 22)),
                    // Mostramos la región seleccionada como referencia
                    if (widget.city != null)
                      Text("Buscando en ${widget.city}", style: TextStyle(color: theme.accentColor, fontSize: 12))
                    else 
                      Text("Buscando en ${widget.countryCode}", style: TextStyle(color: theme.secondaryText, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildQuickButtons(l10n, theme),
          const SizedBox(height: 20),
          _buildWeekdayLabels(theme),
        ],
      ),
    );
  }

  Widget _buildQuickButtons(AppLocalizations l10n, _CalendarTheme theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _quickSelectChip(l10n.calendarToday, DateTime.now(), theme),
        _quickSelectChip(l10n.calendarTomorrow, DateTime.now().add(const Duration(days: 1)), theme),
        _quickSelectChip(l10n.calendarWeek, null, theme, rangeWeek: true),
        _quickSelectChip(l10n.calendarMonth, null, theme, rangeNext30Days: true),
      ],
    );
  }

  Widget _buildWeekdayLabels(_CalendarTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
          .map((d) => Text(d, style: TextStyle(color: theme.secondaryText, fontWeight: FontWeight.bold, fontSize: 14)))
          .toList(),
    );
  }

  Widget _buildCalendarList(List<DateTime> months, _CalendarTheme theme) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: months.length,
        itemBuilder: (context, index) => _buildMonthSection(months[index], theme),
      ),
    );
  }

  Widget _buildMonthSection(DateTime month, _CalendarTheme theme) {
    final String locale = Localizations.localeOf(context).languageCode;
    final monthName = DateFormat('MMMM yyyy', locale).format(month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // Calcular el día de la semana en que empieza el mes (1 = Lunes, 7 = Domingo)
    final firstWeekday = DateTime(month.year, month.month, 1).weekday;
    // Offset para cuadrar con GridView (Lunes es index 0 en UI, pero DateTime.weekday 1)
    final offset = firstWeekday - 1; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(monthName[0].toUpperCase() + monthName.substring(1),
              style: TextStyle(color: theme.primaryText, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemCount: daysInMonth + offset, // Añadimos espacios vacíos al principio
          itemBuilder: (context, index) {
            if (index < offset) return const SizedBox(); // Espacio vacío
            final day = index - offset + 1;
            return _buildDayTile(DateTime(month.year, month.month, day), theme);
          },
        ),
      ],
    );
  }

  Widget _buildDayTile(DateTime date, _CalendarTheme theme) {
    final bool isPast = date.isBefore(DateTime(currentDate.year, currentDate.month, currentDate.day));
    final bool isToday = DateUtils.isSameDay(date, currentDate);
    final bool isSelected = DateUtils.isSameDay(date, startDate) || DateUtils.isSameDay(date, endDate);
    final bool isBetween = startDate != null && endDate != null && date.isAfter(startDate!) && date.isBefore(endDate!);

    return GestureDetector(
      onTap: isPast ? null : () => _onDateTap(date),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.accentColor : (isBetween ? theme.rangeColor : Colors.transparent),
          shape: BoxShape.circle,
          border: isToday ? Border.all(color: theme.accentColor, width: 1.5) : null,
        ),
        child: Text(
          date.day.toString(),
          style: TextStyle(
            color: isPast ? theme.pastDateColor : (isSelected || isBetween ? Colors.black : theme.primaryText),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(AppLocalizations l10n, _CalendarTheme theme) {
    final bool hasSelection = startDate != null || endDate != null;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: hasSelection ? () => _navigateToConcerts() : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: theme.accentColor,
            disabledBackgroundColor: theme.disabledColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(_getButtonLabel(l10n), style: const TextStyle(fontSize: 18, color: Colors.black)),
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES ---

  Widget _quickSelectChip(String label, DateTime? date, _CalendarTheme theme, {bool rangeWeek = false, bool rangeNext30Days = false}) {
    final isActive = activeQuickButton == label;
    return GestureDetector(
      onTap: () => _onQuickSelect(label, date, rangeWeek: rangeWeek, rangeNext30Days: rangeNext30Days),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? theme.accentColor : theme.inactiveChipColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label, style: TextStyle(color: isActive ? Colors.black : theme.primaryText, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  String _getButtonLabel(AppLocalizations l10n) {
    if (startDate == null && endDate == null) return l10n.calendarBtnSelect;
    final locale = Localizations.localeOf(context).languageCode;
    final format = DateFormat('d MMMM', locale);
    if (endDate == null || DateUtils.isSameDay(startDate, endDate)) return format.format(startDate!).toUpperCase();
    return "${format.format(startDate!)} -> ${format.format(endDate!)}".toUpperCase();
  }

  void _navigateToConcerts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConcertsInRangeScreen(
          startDate: startDate ?? endDate!,
          endDate: endDate ?? startDate!,
          // --- AQUÍ PASAMOS LOS DATOS DE REGIÓN ---
          countryCode: widget.countryCode,
          city: widget.city,
        ),
      ),
    );
  }
}

// --- HELPER DE TEMA ---

class _CalendarTheme {
  final Color scaffoldBg;
  final Color headerBg;
  final Color primaryText;
  final Color secondaryText;
  final Color accentColor;
  final Color rangeColor;
  final Color pastDateColor;
  final Color inactiveChipColor;
  final Color disabledColor;

  _CalendarTheme(ThemeData theme)
      : scaffoldBg = theme.scaffoldBackgroundColor,
        headerBg = theme.brightness == Brightness.dark ? Colors.black : const Color(0xFFF7F7F7),
        primaryText = theme.brightness == Brightness.dark ? Colors.white : const Color(0xFF222222),
        secondaryText = theme.brightness == Brightness.dark ? Colors.white54 : Colors.grey.shade600,
        accentColor = Colors.greenAccent,
        // Usamos withOpacity para mayor compatibilidad
        rangeColor = Colors.greenAccent.withOpacity(0.2),
        pastDateColor = theme.brightness == Brightness.dark ? Colors.white38 : Colors.grey.shade400,
        inactiveChipColor = theme.brightness == Brightness.dark 
            ? Colors.greenAccent.withOpacity(0.2) 
            : Colors.grey.shade300,
        disabledColor = theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300;
}