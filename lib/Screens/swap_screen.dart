import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SwapScreen extends StatefulWidget {
  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  XFile? _baseImage;
  XFile? _clothesImage;
  String _category = 'upper_body';
  String? _resultImageUrl;
  bool _isLoading = false; // Added variable for loading state
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isBaseImage) async {
    print('Image selection started.');
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isBaseImage) {
          _baseImage = image;
          print('Person image selected.');
        } else {
          _clothesImage = image;
          print('Clothes image selected.');
        }
      });
    } else {
      print('no image selected');
    }
  }

  Future<void> _swapClothes() async {
    if (_baseImage == null || _clothesImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please select both images.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      print('Please select both image and text prompt.');
      return;
    }

    final request = http.MultipartRequest('POST',
        Uri.parse('https://web-production-27e6.up.railway.app/swap-clothes'));

    request.files.add(await http.MultipartFile.fromPath(
      'person_image',
      _baseImage!.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'clothes_design',
      _clothesImage!.path,
    ));
    request.fields['category'] = _category;

    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Request successful.');
        final responseBody = await response.stream.bytesToString();
        final responseData = responseBody.replaceAll('"', '');
        setState(() {
          _resultImageUrl = responseData;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Request failed with error: $e');
    } finally {
      setState(() {
        _isLoading = false;
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
                        onPressed: () => _pickImage(true),
                        child: const Text('Select Base Image'),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _clothesImage == null
                          ? const Text('No clothes image selected.')
                          : Image.file(File(_clothesImage!.path)),
                      ElevatedButton(
                        onPressed: () => _pickImage(false),
                        child: const Text('Select Clothes Image'),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
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
                  onPressed: _swapClothes,
                  child: const Text(
                    'Swap Clothes',
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
