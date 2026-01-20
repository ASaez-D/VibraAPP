import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileLoggerOutput extends LogOutput {
  File? _appLogFile;
  File? _errorLogFile;
  bool _initialized = false;

  FileLoggerOutput() {
    _initFiles();
  }

  Future<void> _initFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      _appLogFile = File('${logDir.path}/app.log');
      _errorLogFile = File('${logDir.path}/error.log');
      
      _initialized = true;
      debugPrint("📁 Logs listos en: ${logDir.path}");
    } catch (e) {
      debugPrint("❌ Error inicializando logs: $e");
    }
  }

  @override
  void output(OutputEvent event) {
    if (!_initialized) {
      for (var line in event.lines) {
        debugPrint(line);
      }
      return;
    }

    final message = event.lines.join('\n');
    final timestamp = DateTime.now().toIso8601String();
    final logLine = "[$timestamp] [${event.level.name.toUpperCase()}] $message\n";

    _writeTo(_appLogFile, logLine);

    if (event.level == Level.error || event.level == Level.fatal) {
      _writeTo(_errorLogFile, logLine);
    }
  }

  // Corregido con async/try-catch
  Future<void> _writeTo(File? file, String text) async {
    if (file == null) return;
    try {
      await file.writeAsString(text, mode: FileMode.append, flush: true);
    } catch (e) {
      debugPrint("Error escribiendo en log: $e");
    }
  }
}