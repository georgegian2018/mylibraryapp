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
