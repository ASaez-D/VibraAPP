import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileLoggerOutput extends LogOutput {
  File? _appLogFile;
  File? _errorLogFile;

  FileLoggerOutput() {
    _initFiles();
  }

  Future<void> _initFiles() async {
    try {
      // 1. Obtenemos la ruta segura del dispositivo
      final directory = await getApplicationDocumentsDirectory();
      
      // 2. Creamos la carpeta 'logs' ESPECÍFICA
      final logDir = Directory('${directory.path}/logs');
      
      // Si la carpeta no existe, la creamos
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      // 3. Definimos los dos archivos dentro de esa carpeta
      _appLogFile = File('${logDir.path}/app.log');
      _errorLogFile = File('${logDir.path}/error.log');
      
      // Mensaje de control en consola
      print("📁 LOGS LISTOS EN: ${logDir.path}");
      print("   📄 General: app.log");
      print("   📄 Errores: error.log");
      
    } catch (e) {
      print("❌ Error iniciando el sistema de archivos de logs: $e");
    }
  }

  @override
  void output(OutputEvent event) {
    // Si el sistema de archivos aún no ha inicializado, no hacemos nada
    if (_appLogFile == null || _errorLogFile == null) return;

    // Preparamos el mensaje
    final message = event.lines.join('\n');
    final timestamp = DateTime.now().toIso8601String();
    final logLine = "[$timestamp] [${event.level.name.toUpperCase()}] $message\n";

    // --- REGLAS DE ESCRITURA ---
    
    // 1. TODO va al app.log (Historial completo)
    _writeTo(_appLogFile!, logLine);

    // 2. Solo los ERRORES (y fatales) van al error.log
    if (event.level == Level.error || event.level == Level.fatal) {
      _writeTo(_errorLogFile!, logLine);
    }
  }

  void _writeTo(File file, String text) {
    // Escribimos al final del archivo (Append) para no borrar lo anterior
    try {
      file.writeAsString(text, mode: FileMode.append, flush: true);
    } catch (e) {
      print("Error escribiendo en log: $e");
    }
  }
}