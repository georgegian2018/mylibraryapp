// lib/services/file_service.dart
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileService {
  static Future<String> saveBibTeX(String content, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.bib');
    await file.writeAsString(content);
    return file.path;
  }
}
