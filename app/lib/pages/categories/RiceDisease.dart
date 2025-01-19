import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Disease extends StatefulWidget {
  const Disease({Key? key}) : super(key: key);

  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String _result = '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _result = '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.22.0.150:7000/upload'), // Your local server URL
      );

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ),
      );

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      setState(() {
        _result = responseData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Error uploading image: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Disease Detection',),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview
            if (_image != null) ...[
              const SizedBox(height: 20),
              Image.file(
                _image!,
                height: 300,
                fit: BoxFit.cover,
              ),
            ],

            // Buttons
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),

            // Upload button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _uploadImage,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Upload and Analyze'),
            ),
            // Results
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Results:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(_result),
            ],
          ],
        ),
      ),
    );
  }
}
