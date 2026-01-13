import 'package:logger/logger.dart';
import 'file_logger_output.dart'; 

final logger = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8, 
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
  output: MultiOutput([
    ConsoleOutput(),    
    FileLoggerOutput(), 
  ]),
);