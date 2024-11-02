// lib/screens/add_document_screen.dart
import 'package:flutter/material.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import 'package:file_picker/file_picker.dart';

class AddDocumentScreen extends StatefulWidget {
  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _filePath;
  String _title = '';
  String _author = '';
  String _type = '';

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _saveDocument() async {
    if (_formKey.currentState?.validate() == true && _filePath != null) {
      final newDocument = Document(
        filePath: _filePath!,
        title: _title,
        author: _author,
        type: _type,
        tags: [], // Empty by default, can be added later
      );

      await DatabaseService().insertDocument(newDocument);
      Navigator.pop(context); // Go back to LibraryScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Document')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: Text(_filePath == null ? 'Select Document' : 'Document Selected'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => _title = value,
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                onChanged: (value) => _author = value,
                validator: (value) => value == null || value.isEmpty ? 'Author is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type'),
                onChanged: (value) => _type = value,
                validator: (value) => value == null || value.isEmpty ? 'Type is required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDocument,
                child: Text('Save Document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
