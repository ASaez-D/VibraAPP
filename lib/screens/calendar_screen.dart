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
    final monthsList = <DateTime>[];

    for (int i = 0; i < 12; i++) {
      monthsList.add(DateTime(currentDate.year, currentDate.month + i));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "¿Cuándo quieres salir?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // QUICK BUTTONS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _quickSelectButton("Hoy", DateTime.now()),
                      _quickSelectButton(
                          "Mañana", DateTime.now().add(const Duration(days: 1))),
                      _quickSelectButton("Esta semana", null, rangeWeek: true),
                      _quickSelectButton("Próximos 30 días", null,
                          rangeNext30Days: true),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // WEEKDAY LABELS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                        .map(
                          (d) => Text(
                            d,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                  return _buildMonthCalendar(monthsList[index]);
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
                    backgroundColor: Colors.greenAccent,
                    disabledBackgroundColor: Colors.grey.shade800,
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

    // Si solo queda endDate
    if (sd == null && ed != null) {
      return DateFormat('d MMMM', 'es_ES').format(ed).toUpperCase();
    }

    // Si solo queda startDate
    if (sd != null && ed == null) {
      return DateFormat('d MMMM', 'es_ES').format(sd).toUpperCase();
    }

    // Si ambos existen
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
  Widget _quickSelectButton(String label, DateTime? date,
      {bool rangeWeek = false, bool rangeNext30Days = false}) {
    final isActive = activeQuickButton == label;

    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.greenAccent
              : Colors.greenAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
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
  Widget _buildMonthCalendar(DateTime month) {
    final monthName = _getMonthName(month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "$monthName ${month.year}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
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

            final isSelectedStart = startDate != null && date == startDate;
            final isSelectedEnd = endDate != null && date == endDate;
            final isBetween = startDate != null &&
                endDate != null &&
                date.isAfter(startDate!) &&
                date.isBefore(endDate!);

            final isToday = date ==
                DateTime(
                    currentDate.year, currentDate.month, currentDate.day);

            return GestureDetector(
              onTap: isPast
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        if (isQuickSelection) {
                          // Si venimos de un botón rápido, desactivamos el modo rápido
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

                          // Swap si hace falta
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
                        ? Colors.greenAccent
                        : isBetween
                            ? Colors.greenAccent.withOpacity(0.3)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday
                        ? Border.all(color: Colors.greenAccent, width: 1.5)
                        : null,
                  ),
                  child: AnimatedScale(
                    scale: isSelectedStart || isSelectedEnd ? 1.2 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isPast
                            ? Colors.white38
                            : isSelectedStart ||
                                    isSelectedEnd ||
                                    isBetween
                                ? Colors.black
                                : Colors.white,
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

