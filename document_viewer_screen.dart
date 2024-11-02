// lib/screens/document_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String filePath;

  DocumentViewerScreen({required this.filePath});

  @override
  _DocumentViewerScreenState createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.filePath),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Viewer'),
      ),
      body: PdfView(
        controller: _pdfController,
        onDocumentLoaded: (document) {
          print('Document loaded with ${document.pagesCount} pages');
        },
        onPageChanged: (page) {
          print('Page changed to $page');
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () => _pdfController.previousPage(),
          ),
          FloatingActionButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () => _pdfController.nextPage(),
          ),
        ],
      ),
    );
  }
}

// Inside the ListTile onTap in LibraryScreen
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DocumentViewerScreen(filePath: document.filePath),
    ),
  );
},


// Inside _DocumentViewerScreenState in document_viewer_screen.dart
void _addAnnotation(int page) async {
  final annotationText = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Annotation'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter your comment'),
        onChanged: (value) => annotationText = value,
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () => Navigator.pop(context, annotationText),
        ),
      ],
    ),
  );

  if (annotationText != null) {
    final newAnnotation = Annotation(page: page, comment: annotationText);
    await AnnotationService().addAnnotation(document.id!, newAnnotation);
    setState(() {
      document.annotations.add(newAnnotation);
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Document Viewer')),
    body: PdfView(
      controller: _pdfController,
      onPageChanged: (page) {
        _currentPage = page;
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.note_add),
      onPressed: () => _addAnnotation(_currentPage),
    ),
  );
}
