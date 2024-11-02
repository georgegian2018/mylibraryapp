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
