import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drag and Drop Image')),
        body: DragDropImage(),
      ),
    );
  }
}

class DragDropImage extends StatefulWidget {
  @override
  _DragDropImageState createState() => _DragDropImageState();
}

class _DragDropImageState extends State<DragDropImage> {
  // To hold the dropped image data (as bytes)
  Uint8List? _imageBytes;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DragTarget<List<html.File>>(
            onAccept: (files) async {
              // Handle file drop
              final file = files.first;
              final reader = html.FileReader();
              print('file: $file');
              // Read the file as bytes
              reader.readAsArrayBuffer(file);
              reader.onLoadEnd.listen((e) {
                setState(() {
                  _imageBytes = reader.result as Uint8List;
                });
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  color: Colors.blue.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    "Drag an image here",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          _imageBytes == null
              ? Text('No image dropped yet.')
              : Image.memory(_imageBytes!), // Display the image after drop
        ],
      ),
    );
  }
}
