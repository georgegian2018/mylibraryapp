// lib/utils/bibtex_formatter.dart
import '../models/document.dart';

class BibTeXFormatter {
  static String format(Document document) {
    final buffer = StringBuffer();
    buffer.writeln('@article{${document.id},');
    buffer.writeln('  title = {${document.title}},');
    buffer.writeln('  author = {${document.author}},');
    if (document.publicationDate != null) {
      buffer.writeln('  year = {${document.publicationDate!.year}},');
    }
    buffer.writeln('  type = {${document.type}},');
    buffer.writeln('  note = {${document.notes}},');
    buffer.writeln('}');
    return buffer.toString();
  }
}