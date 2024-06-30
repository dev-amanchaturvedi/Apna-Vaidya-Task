import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  XFile? _baseImage;
  String _textPrompt = '';
  String _category = 'upper_body';
  String? _resultImageUrl;
  bool _isLoading = false; // Added variable for loading state
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    print('Image selection started.');
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _baseImage = image;
        print('Person image selected: ${image.path}');
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _createClothes() async {
    if (_baseImage == null || _textPrompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Select an image and enter a text prompt.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      print('Please select both image and text prompt.');
      return;
    }

    final Uri url =
        Uri.parse('https://web-production-27e6.up.railway.app/create');
    final request = http.MultipartRequest('POST', url);

    try {
      final file = await http.MultipartFile.fromPath('file', _baseImage!.path);
      request.files.add(file);
      print('File attached: ${file.filename}');
    } catch (e) {
      print('Error attaching file: $e');
      return;
    }

    request.fields['category'] = _category;
    request.fields['text_prompt'] = _textPrompt;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    print('Sending request to FastAPI...');
    print('Request fields: ${request.fields}');
    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Request successful.');
        final responseBody = await response.stream.bytesToString();
        final responseData = responseBody.replaceAll('"', '');
        print('Response data: $responseData');

        setState(() {
          _resultImageUrl = responseData;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('Request failed with error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E2EB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _baseImage == null
                          ? const Text('No base image selected.')
                          : Image.file(File(_baseImage!.path)),
                      ElevatedButton(
                        onPressed: () => _pickImage(),
                        child: const Text('Select Base Image'),
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Text Prompt'),
                onChanged: (value) {
                  setState(() {
                    _textPrompt = value;
                  });
                },
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: _category,
                    items: ['upper_body', 'lower_body', 'dresses']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: RawMaterialButton(
                  fillColor: Colors.deepPurple.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: _createClothes,
                  child: const Text(
                    'Create Clothes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator() // Show progress indicator
                  : _resultImageUrl == null
                      ? Container()
                      : Image.network(_resultImageUrl!),
            ],
          ),
        ),
      ),
    );
  }
}
