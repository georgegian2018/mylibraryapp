// lib/services/annotation_service.dart
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';
import '../models/document.dart';

class AnnotationService {
  Future<void> addAnnotation(int documentId, Annotation annotation) async {
    final db = await DatabaseService().database;
    await db.insert(
      'annotations',
      {
        'document_id': documentId,
        'page': annotation.page,
        'comment': annotation.comment,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Annotation>> getAnnotations(int documentId) async {
    final db = await DatabaseService().database;
    final maps = await db.query(
      'annotations',
      where: 'document_id = ?',
      whereArgs: [documentId],
    );

    return maps.map((map) => Annotation.fromMap(map)).toList();
  }
}


// Display annotations within build method
Column(
  children: [
    Expanded(
      child: PdfView(controller: _pdfController),
    ),
    Expanded(
      child: ListView(
        children: document.annotations
            .where((annotation) => annotation.page == _currentPage)
            .map((annotation) => ListTile(
                  title: Text(annotation.comment),
                ))
            .toList(),
      ),
    ),
  ],
);
