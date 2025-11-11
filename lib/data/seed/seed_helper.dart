import 'dart:developer' as dev;
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Helper para reiniciar la base de datos y cargar datos de seed
class SeedHelper {
  /// Elimina la base de datos para forzar su recreación
  /// Útil durante el desarrollo para probar el seed de datos
  static Future<void> resetDatabase() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDirectory.path, 'gym_tracker.db');
      final dbFile = File(dbPath);
      
      if (await dbFile.exists()) {
        await dbFile.delete();
        dev.log('Database deleted successfully at: $dbPath');
      } else {
        dev.log('Database file not found at: $dbPath');
      }
    } catch (e) {
      dev.log('Error deleting database: $e');
    }
  }
}
