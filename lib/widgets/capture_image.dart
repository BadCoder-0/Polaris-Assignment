import 'package:flutter/material.dart';
class CaptureImagesField extends StatefulWidget {
  final String label;
  final int noOfImagesToCapture;
  final String savingFolder;
  final Function(List<String>) onChanged;

  CaptureImagesField(
      {required this.label,
        required this.noOfImagesToCapture,
        required this.savingFolder,
        required this.onChanged});

  @override
  _CaptureImagesFieldState createState() => _CaptureImagesFieldState();
}

class _CaptureImagesFieldState extends State<CaptureImagesField> {
  List<String> _imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // Placeholder for capturing images logic
              },
              child: Text('Capture Image'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // Placeholder for clearing selected images logic
                setState(() {
                  _imagePaths.clear();
                });
                widget.onChanged(_imagePaths);
              },
              child: Text('Clear Images'),
            ),
          ],
        ),
        SizedBox(height: 8),
        _imagePaths.isEmpty
            ? Text('No images selected')
            : Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _imagePaths.length,
            itemBuilder: (context, index) {
              return Image.network(
                _imagePaths[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ],
    );
  }
}