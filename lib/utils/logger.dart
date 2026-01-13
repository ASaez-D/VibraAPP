import 'package:logger/logger.dart';
import 'file_logger_output.dart'; // Importamos la clase de arriba

final logger = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8, // Mostrar pila de llamadas en errores
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
  output: MultiOutput([
    ConsoleOutput(),    // Salida por consola de VS Code
    FileLoggerOutput(), // Salida a los archivos app.log y error.log
  ]),
);