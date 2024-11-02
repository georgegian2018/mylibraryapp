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
