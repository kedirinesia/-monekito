import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/core/presentation/widgets/direct_image_picker.dart';
import 'package:monekito/core/services/image_picker_service.dart';

class ImagePickerTestPage extends StatefulWidget {
  const ImagePickerTestPage({super.key});

  @override
  State<ImagePickerTestPage> createState() => _ImagePickerTestPageState();
}

class _ImagePickerTestPageState extends State<ImagePickerTestPage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Image Picker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Image Picker Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Image Selector Widget
            const Text(
              'Image Selector Widget:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Center(
              child: DirectImagePicker(
                size: 120,
                placeholderText: 'Tap to select image',
                onImageSelected: (File? image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // Action Buttons
            const Text(
              'Direct Actions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.image),
                label: const Text('Choose Source'),
              ),
            ),
            const SizedBox(height: 20),
            
            // Display selected image
            if (_selectedImage != null) ...[
              const Text(
                'Selected Image:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'File: ${_selectedImage!.path.split('/').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.pickImageFromGallery(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
      _showSuccessMessage('Image selected from gallery!');
    }
  }

  Future<void> _pickFromCamera() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.pickImageFromCamera(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
      _showSuccessMessage('Photo taken with camera!');
    }
  }

  Future<void> _showImageSourceDialog() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.showImageSourceDialog(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
      _showSuccessMessage('Image selected!');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
