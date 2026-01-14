import 'package:flutter/material.dart';
import 'concerts_in_range_screen.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? startDate;
  DateTime? endDate;

  final currentDate = DateTime.now();
  String activeQuickButton = '';
  bool isQuickSelection = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Detección del tema y Colores Dinámicos
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final Color headerBg = isDarkMode ? Colors.black : const Color(0xFFF7F7F7);
    final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);
    final Color secondaryText = isDarkMode ? Colors.white54 : Colors.grey.shade600;
    final Color accentColor = Colors.greenAccent; 

    final monthsList = <DateTime>[];

    for (int i = 0; i < 12; i++) {
      monthsList.add(DateTime(currentDate.year, currentDate.month + i));
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              color: headerBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- AQUÍ ESTÁ EL CAMBIO: TÍTULO CON BOTÓN ATRÁS ---
                  Row(
                    children: [
                      // Botón Atrás
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, color: primaryText, size: 22),
                        onPressed: () => Navigator.pop(context), // Vuelve atrás
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(), // Quita márgenes extra
                      ),
                      const SizedBox(width: 16),
                      // Título
                      Expanded(
                        child: Text(
                          "¿Cuándo quieres salir?",
                          style: TextStyle(
                            color: primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 22, // Un pelín más pequeño para ajustar
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ---------------------------------------------------

                  const SizedBox(height: 20),

                  // QUICK BUTTONS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _quickSelectButton("Hoy", DateTime.now(), accentColor, primaryText), 
                      _quickSelectButton(
                          "Mañana", DateTime.now().add(const Duration(days: 1)), accentColor, primaryText), 
                      _quickSelectButton("Esta semana", null, accentColor, primaryText, rangeWeek: true), 
                      _quickSelectButton("Próximos 30 días", null, accentColor, primaryText,
                          rangeNext30Days: true), 
                    ],
                  ),

                  const SizedBox(height: 20),

                  // WEEKDAY LABELS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                        .map(
                          (d) => Text(
                            d,
                            style: TextStyle(
                              color: secondaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            // CALENDAR
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: monthsList.length,
                itemBuilder: (context, index) {
                  return _buildMonthCalendar(monthsList[index], primaryText, secondaryText, accentColor);
                },
              ),
            ),

            // BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (startDate != null || endDate != null)
                      ? () {
                            final sd = startDate ?? endDate!;
                            final ed = endDate ?? startDate!;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConcertsInRangeScreen(
                                  startDate: sd,
                                  endDate: ed,
                                ),
                              ),
                            );
                          }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: accentColor, 
                    disabledBackgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _getButtonLabel(),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // GET BUTTON LABEL
  // ---------------------------------------------------------
  String _getButtonLabel() {
    final sd = startDate;
    final ed = endDate;

    if (sd == null && ed == null) {
      return "ESCOGER FECHA";
    }

    if (sd == null && ed != null) {
      return DateFormat('d MMMM', 'es_ES').format(ed).toUpperCase();
    }

    if (sd != null && ed == null) {
      return DateFormat('d MMMM', 'es_ES').format(sd).toUpperCase();
    }

    if (sd!.isAtSameMomentAs(ed!)) {
      return DateFormat('d MMMM', 'es_ES').format(sd).toUpperCase();
    }

    return "${DateFormat('d MMMM', 'es_ES').format(sd)} -> "
        "${DateFormat('d MMMM', 'es_ES').format(ed)}"
        .toUpperCase();
  }

  // ---------------------------------------------------------
  // QUICK SELECT BUTTONS
  // ---------------------------------------------------------
  Widget _quickSelectButton(String label, DateTime? date, Color accentColor, Color primaryText,
      {bool rangeWeek = false, bool rangeNext30Days = false}) {
    final isActive = activeQuickButton == label;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color inactiveColor = isDarkMode 
      ? accentColor.withOpacity(0.2) 
      : Colors.grey.shade300;

    final Color inactiveTextColor = isDarkMode ? Colors.white : primaryText;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          activeQuickButton = label;
          isQuickSelection = true;
          startDate = null;
          endDate = null;

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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? accentColor
              : inactiveColor, 
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : inactiveTextColor, 
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // MONTH CALENDAR
  // ---------------------------------------------------------
  Widget _buildMonthCalendar(DateTime month, Color primaryText, Color secondaryText, Color accentColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final monthName = _getMonthName(month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    
    final Color pastDateColor = isDarkMode ? Colors.white38 : Colors.grey.shade400;
    final Color rangeColor = isDarkMode ? accentColor.withOpacity(0.3) : accentColor.withOpacity(0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "$monthName ${month.year}",
          style: TextStyle(
            color: primaryText, 
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, dayIndex) {
            final day = dayIndex + 1;
            final date = DateTime(month.year, month.month, day);

            final isPast = date.isBefore(DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
            ));

            final isSelectedStart = startDate != null && 
                date.year == startDate!.year &&
                date.month == startDate!.month &&
                date.day == startDate!.day;

            final isSelectedEnd = endDate != null && 
                date.year == endDate!.year &&
                date.month == endDate!.month &&
                date.day == endDate!.day;

            final isBetween = startDate != null &&
                endDate != null &&
                date.isAfter(startDate!) &&
                date.isBefore(endDate!);

            final isToday = date.year == currentDate.year &&
                date.month == currentDate.month &&
                date.day == currentDate.day;

            return GestureDetector(
              onTap: isPast
                  ? null
                  : () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          if (isQuickSelection) {
                            isQuickSelection = false;
                            activeQuickButton = '';
                          } else {
                            if (isSelectedStart) {
                              startDate = null;
                            } else if (isSelectedEnd) {
                              endDate = null;
                            } else if (startDate == null) {
                              startDate = date;
                            } else if (endDate == null) {
                              endDate = date;
                            } else {
                              startDate = date;
                              endDate = null;
                            }

                            if (startDate != null &&
                                endDate != null &&
                                startDate!.isAfter(endDate!)) {
                              final temp = startDate;
                              startDate = endDate;
                              endDate = temp;
                            }

                            activeQuickButton = '';
                          }
                        });
                      },
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelectedStart || isSelectedEnd
                        ? accentColor 
                        : isBetween
                            ? rangeColor 
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday
                        ? Border.all(color: accentColor, width: 1.5) 
                        : null,
                  ),
                  child: AnimatedScale(
                    scale: isSelectedStart || isSelectedEnd ? 1.1 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isPast
                            ? pastDateColor 
                            : isSelectedStart ||
                                    isSelectedEnd ||
                                    isBetween
                                ? Colors.black 
                                : primaryText, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    return months[month - 1];
  }
}