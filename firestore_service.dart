// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document.dart';

class FirestoreService {
  final CollectionReference _documentCollection =
      FirebaseFirestore.instance.collection('documents');

  Future<void> addDocumentToCloud(Document document) async {
    await _documentCollection.doc(document.id.toString()).set(document.toMap());
  }

  Future<List<Document>> fetchDocumentsFromCloud() async {
    final snapshot = await _documentCollection.get();
    return snapshot.docs.map((doc) => Document.fromMap(doc.data())).toList();
  }
}
