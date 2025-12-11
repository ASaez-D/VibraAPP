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

  final Color accentColor = Colors.greenAccent;

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
    // 1. Obtener el estado del tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final headerBgColor = isDark ? Colors.black : Colors.white;
    final bodyBgColor = Theme.of(context).scaffoldBackgroundColor;
    final disabledQuickButtonColor = isDark
        ? Colors.greenAccent.withOpacity(0.2)
        : Colors.greenAccent.withOpacity(0.1);
    final disabledQuickButtonTextColor = isDark ? Colors.white : Colors.black;
    final weekdayLabelColor = isDark ? Colors.white54 : Colors.black54;
    final disabledDayColor = isDark ? Colors.white38 : Colors.black38;
    final disabledButtonBgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;


    final monthsList = <DateTime>[];

    for (int i = 0; i < 12; i++) {
      monthsList.add(DateTime(currentDate.year, currentDate.month + i));
    }

    return Scaffold(
      // Usamos el color de fondo del tema
      backgroundColor: bodyBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              // Color de fondo del encabezado adaptado
              color: headerBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¿Cuándo quieres salir?",
                    style: TextStyle(
                      // Color de texto adaptado
                      color: mainTextColor,
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
                      _quickSelectButton(
                        "Hoy",
                        DateTime.now(),
                        disabledColor: disabledQuickButtonColor,
                        activeColor: accentColor,
                        disabledTextColor: disabledQuickButtonTextColor,
                      ),
                      _quickSelectButton(
                          "Mañana", DateTime.now().add(const Duration(days: 1)),
                          disabledColor: disabledQuickButtonColor,
                          activeColor: accentColor,
                          disabledTextColor: disabledQuickButtonTextColor),
                      _quickSelectButton("Esta semana", null,
                          rangeWeek: true,
                          disabledColor: disabledQuickButtonColor,
                          activeColor: accentColor,
                          disabledTextColor: disabledQuickButtonTextColor),
                      _quickSelectButton("Próximos 30 días", null,
                          rangeNext30Days: true,
                          disabledColor: disabledQuickButtonColor,
                          activeColor: accentColor,
                          disabledTextColor: disabledQuickButtonTextColor),
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
                            style: TextStyle(
                              // Color de etiqueta adaptado
                              color: weekdayLabelColor,
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
                  return _buildMonthCalendar(
                    monthsList[index], 
                    mainTextColor: mainTextColor,
                    accentColor: accentColor,
                    disabledDayColor: disabledDayColor,
                  );
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
                    // Color de fondo desactivado adaptado
                    disabledBackgroundColor: disabledButtonBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _getButtonLabel(),
                    // Color de texto adaptado (siempre negro en este acento)
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

    // Si solo queda endDate (o si sd es posterior a ed, se intercambian antes de aquí)
    if (sd == null && ed != null) {
      return DateFormat('d MMMM', 'es_ES').format(ed).toUpperCase();
    }

    // Si solo queda startDate
    if (sd != null && ed == null) {
      return DateFormat('d MMMM', 'es_ES').format(sd).toUpperCase();
    }

    // Si ambos existen y son el mismo día
    if (sd!.isAtSameMomentAs(ed!)) {
      return DateFormat('d MMMM', 'es_ES').format(sd).toUpperCase();
    }

    // Si ambos existen y son rango
    return "${DateFormat('d MMMM', 'es_ES').format(sd)} -> "
        "${DateFormat('d MMMM', 'es_ES').format(ed)}"
        .toUpperCase();
  }

  // ---------------------------------------------------------
  // QUICK SELECT BUTTONS (Añadimos argumentos de color)
  // ---------------------------------------------------------
  Widget _quickSelectButton(
    String label,
    DateTime? date, {
    bool rangeWeek = false,
    bool rangeNext30Days = false,
    required Color activeColor,
    required Color disabledColor,
    required Color disabledTextColor,
  }) {
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
          color: isActive ? activeColor : disabledColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            // Color adaptado
            color: isActive ? Colors.black : disabledTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // MONTH CALENDAR (Añadimos argumentos de color)
  // ---------------------------------------------------------
  Widget _buildMonthCalendar(
    DateTime month, {
    required Color mainTextColor,
    required Color accentColor,
    required Color disabledDayColor,
  }) {
    final monthName = _getMonthName(month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // Obtener el primer día del mes y su WeekDay (lunes = 1, domingo = 7)
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    // Calcular el desfase: Dart WeekDay (1-7) -> GridView (0-6) (Lunes = 0, Domingo = 6)
    // Usamos el estándar que el primer día de la semana es Lunes (1 en Dart)
    int startWeekdayOffset = firstDayOfMonth.weekday - 1; 

    // Ajuste para el número total de celdas
    final totalCells = daysInMonth + startWeekdayOffset;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "$monthName ${month.year}",
          style: TextStyle(
            // Color adaptado
            color: mainTextColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells, // Usamos el total de celdas necesarias
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            // Celdas vacías al inicio si el mes no comienza en lunes
            if (index < startWeekdayOffset) {
              return Container(); 
            }

            final day = index - startWeekdayOffset + 1;
            final date = DateTime(month.year, month.month, day);

            // Reseteamos la hora para la comparación
            final today = DateTime(currentDate.year, currentDate.month, currentDate.day);
            final dateOnly = DateTime(date.year, date.month, date.day);

            final isPast = dateOnly.isBefore(today);
            final isSelectedStart = startDate != null && dateOnly.isAtSameMomentAs(startDate!);
            final isSelectedEnd = endDate != null && dateOnly.isAtSameMomentAs(endDate!);
            final isBetween = startDate != null &&
                endDate != null &&
                // Aseguramos que la fecha es estrictamente entre el inicio y el fin
                dateOnly.isAfter(startDate!) &&
                dateOnly.isBefore(endDate!);

            final isToday = dateOnly.isAtSameMomentAs(today);
            
            // Si el día supera el número de días del mes, devuelve un contenedor vacío
            if (day > daysInMonth) {
              return Container();
            }

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
                        }
                        
                        // Lógica de selección de rango
                        if (isSelectedStart) {
                          startDate = null;
                        } else if (isSelectedEnd) {
                          endDate = null;
                        } else if (startDate == null) {
                          startDate = dateOnly;
                          endDate = null; // Reiniciar end date si seleccionamos un nuevo inicio
                        } else if (endDate == null) {
                          endDate = dateOnly;
                        } else {
                          // Si ambos están seleccionados, empezar un nuevo rango
                          startDate = dateOnly;
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

                        // Si seleccionamos dos veces el mismo día, se queda solo ese día
                        if (startDate != null && endDate != null && startDate!.isAtSameMomentAs(endDate!)) {
                          endDate = startDate;
                        }

                        activeQuickButton = ''; // Desactiva cualquier botón rápido
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
                        // Color de rango adaptado
                        : isBetween ? accentColor.withOpacity(0.3) : Colors.transparent, 
                    shape: BoxShape.circle,
                    // Borde de "hoy" adaptado
                    border: isToday
                        ? Border.all(color: accentColor, width: 1.5)
                        : null,
                  ),
                  child: AnimatedScale(
                    scale: isSelectedStart || isSelectedEnd ? 1.2 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        // Color del día adaptado
                        color: isPast
                            ? disabledDayColor
                            : isSelectedStart || isSelectedEnd
                                ? Colors.black // Texto negro sobre acento verde
                                : isBetween
                                    ? mainTextColor // Texto normal en rango
                                    : mainTextColor, // Texto normal
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
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];
    return months[month - 1];
  }
}