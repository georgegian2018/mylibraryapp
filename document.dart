// lib/models/document.dart

class Document {
  final int? id; // Optional, for database management
  final String filePath; // Location of the file
  final String title;
  final String author;
  final DateTime? publicationDate;
  final String type; // E.g., Thesis, Journal, Article
  final List<String> tags; // List of tags for categorization
  final String notes; // User-added notes

  Document({
    this.id,
    required this.filePath,
    required this.title,
    required this.author,
    this.publicationDate,
    required this.type,
    this.tags = const [],
    this.notes = '',
  });

  // Method to convert Document instance to a map (for database storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'title': title,
      'author': author,
      'publicationDate': publicationDate?.toIso8601String(),
      'type': type,
      'tags': tags.join(','), // Storing as comma-separated values
      'notes': notes,
    };
  }

  // Method to create a Document from a map (for database retrieval)
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      filePath: map['filePath'],
      title: map['title'],
      author: map['author'],
      publicationDate: map['publicationDate'] != null
          ? DateTime.parse(map['publicationDate'])
          : null,
      type: map['type'],
      tags: map['tags']?.split(',') ?? [],
      notes: map['notes'] ?? '',
    );
  }
}





// lib/models/document.dart
class Annotation {
  final int page;
  final String comment;

  Annotation({required this.page, required this.comment});

  Map<String, dynamic> toMap() {
    return {'page': page, 'comment': comment};
  }

  factory Annotation.fromMap(Map<String, dynamic> map) {
    return Annotation(
      page: map['page'],
      comment: map['comment'],
    );
  }
}

class Document {
  // Existing fields...
  List<Annotation> annotations;

  Document({
    // Existing parameters...
    this.annotations = const [],
  });

  Map<String, dynamic> toMap() {
    // Existing mapping...
    'annotations': annotations.map((e) => e.toMap()).toList(),
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    // Existing code...
    annotations: (map['annotations'] as List)
        .map((annotation) => Annotation.fromMap(annotation))
        .toList(),
  }
}
