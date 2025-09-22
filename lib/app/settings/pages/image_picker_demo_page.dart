import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/core/presentation/widgets/image_selector_widget.dart';
import 'package:monekito/core/services/image_picker_service.dart';

class ImagePickerDemoPage extends StatefulWidget {
  const ImagePickerDemoPage({super.key});

  @override
  State<ImagePickerDemoPage> createState() => _ImagePickerDemoPageState();
}

class _ImagePickerDemoPageState extends State<ImagePickerDemoPage> {
  File? _selectedImage;
  File? _categoryImage;
  File? _accountImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Image Picker Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Basic Image Selector
            const Text(
              'Basic Image Selector',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Center(
              child: ImageSelectorWidget(
                selectedImage: _selectedImage,
                size: 100,
                placeholderText: 'Add Image',
                onImageChanged: () {
                  // Handle image change
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // Image Selector with Preview
            const Text(
              'Image Selector with Preview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Center(
              child: ImageSelectorWithPreview(
                initialImage: _selectedImage,
                size: 120,
                placeholderText: 'Select Image',
                onImageSelected: (File? image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // Category Image Example
            const Text(
              'Category Image Example',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ImageSelectorWidget(
                  selectedImage: _categoryImage,
                  defaultAssetPath: 'assets/icons/supported_selectable_icons/food/restaurant.svg',
                  size: 80,
                  placeholderText: 'Category',
                  onImageChanged: () {
                    _selectCategoryImage();
                  },
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Food & Dining',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Tap to change category image',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Account Image Example
            const Text(
              'Account Image Example',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ImageSelectorWidget(
                  selectedImage: _accountImage,
                  defaultAssetPath: 'assets/icons/supported_selectable_icons/money/credit_card.svg',
                  size: 80,
                  placeholderText: 'Account',
                  onImageChanged: () {
                    _selectAccountImage();
                  },
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Bank Account',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Tap to change account image',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Action Buttons
            const Text(
              'Direct Image Picker Actions',
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
                'Selected Image Preview',
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
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectCategoryImage() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.showImageSourceDialog(context);
    
    if (selectedFile != null) {
      setState(() {
        _categoryImage = selectedFile;
      });
    }
  }

  Future<void> _selectAccountImage() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.showImageSourceDialog(context);
    
    if (selectedFile != null) {
      setState(() {
        _accountImage = selectedFile;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.pickImageFromGallery(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.pickImageFromCamera(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.showImageSourceDialog(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
    }
  }
}
