// lib/screens/library_screen.dart
import 'package:flutter/material.dart';
import '../models/document.dart';
import '../services/database_service.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Document>> _documents;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() {
    _documents = DatabaseService().getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Research Library'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Document>>(
        future: _documents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No documents found.'));
          } else {
            final documents = snapshot.data!;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return ListTile(
                  title: Text(document.title),
                  subtitle: Text('${document.author} • ${document.type}'),
                  onTap: () {
                    // TODO: Open Document Viewer
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: Add document functionality
        },
      ),
    );
  }
}



// Modify LibraryScreen to include filter options
class _LibraryScreenState extends State<LibraryScreen> {
  String _searchQuery = '';
  String? _selectedType;

  Future<List<Document>> _filterDocuments() async {
    final allDocs = await DatabaseService().getDocuments();
    return allDocs.where((doc) {
      final matchesQuery = doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.annotations.any((annotation) => annotation.comment.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesType = _selectedType == null || doc.type == _selectedType;

      return matchesQuery && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Search...'),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            DropdownButton<String>(
              value: _selectedType,
              hint: Text('Filter by Type'),
              items: ['Thesis', 'Journal', 'Article', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Document>>(
        future: _filterDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No documents found.'));
          } else {
            final documents = snapshot.data!;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return ListTile(
                  title: Text(document.title),
                  subtitle: Text('${document.author} • ${document.type}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
