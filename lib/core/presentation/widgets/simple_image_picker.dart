import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/core/services/image_picker_service.dart';

class SimpleImagePicker extends StatefulWidget {
  final double size;
  final String? placeholderText;
  final Function(File?)? onImageSelected;

  const SimpleImagePicker({
    super.key,
    this.size = 80.0,
    this.placeholderText,
    this.onImageSelected,
  });

  @override
  State<SimpleImagePicker> createState() => _SimpleImagePickerState();
}

class _SimpleImagePickerState extends State<SimpleImagePicker> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImagePicker,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size / 2),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size / 2),
          child: _buildImageContent(),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: widget.size,
        height: widget.size,
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: widget.size * 0.3,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            if (widget.placeholderText != null)
              Text(
                widget.placeholderText!,
                style: TextStyle(
                  fontSize: widget.size * 0.15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }
  }

  Future<void> _showImagePicker() async {
    // Show bottom sheet with options
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final imagePicker = ImagePickerService();
                  final selectedFile = await imagePicker.pickImageFromGallery(context);
                  
                  if (selectedFile != null) {
                    setState(() {
                      _selectedImage = selectedFile;
                    });
                    widget.onImageSelected?.call(selectedFile);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final imagePicker = ImagePickerService();
                  final selectedFile = await imagePicker.pickImageFromCamera(context);
                  
                  if (selectedFile != null) {
                    setState(() {
                      _selectedImage = selectedFile;
                    });
                    widget.onImageSelected?.call(selectedFile);
                  }
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Image', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedImage = null;
                    });
                    widget.onImageSelected?.call(null);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
