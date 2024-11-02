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

//Update LibraryScreen to navigate to AddDocumentScreen when the floating action button is tapped.

// Inside LibraryScreen's floatingActionButton
floatingActionButton: FloatingActionButton(
  child: Icon(Icons.add),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDocumentScreen()),
    ).then((_) => setState(() {
          _loadDocuments(); // Reload documents on return
        }));
  },
);

//Update LibraryScreen to include a search bar in the AppBar for keyword-based filtering

// Modify LibraryScreen to add search functionality
class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Document>> _documents;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() {
    _documents = DatabaseService().getDocuments();
  }

  Future<List<Document>> _filterDocuments() async {
    final allDocs = await _documents;
    return allDocs.where((doc) {
      final lowerQuery = _searchQuery.toLowerCase();
      return doc.title.toLowerCase().contains(lowerQuery) ||
             doc.author.toLowerCase().contains(lowerQuery) ||
             doc.type.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search...'),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
      ),
      body: FutureBuilder<List<Document>>(
        future: _filterDocuments(),
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
                );
              },
            );
          }
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

// Add a tag filter similar to type filter if needed
List<String> _selectedTags = [];

// Filter logic:
final matchesTags = _selectedTags.isEmpty || _selectedTags.any((tag) => doc.tags.contains(tag));

// Modify LibraryScreen to include an export option
void _exportReferences(List<Document> documents) {
  final bibtexEntries = documents.map((doc) => BibTeXFormatter.format(doc)).join('\n\n');
  // You can use a file saving or sharing plugin here to save `bibtexEntries`
  print(bibtexEntries); // For debugging, print the BibTeX output
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Research Library'),
      actions: [
        IconButton(
          icon: Icon(Icons.download),
          onPressed: () {
            // Export all documents or allow selection for exporting specific documents
            _exportReferences(documents);
          },
        ),
      ],
    ),
    // Rest of the LibraryScreen code...
  );
}

