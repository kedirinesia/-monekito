import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/core/services/image_picker_service.dart';

class DirectImagePicker extends StatefulWidget {
  final double size;
  final String? placeholderText;
  final Function(File?)? onImageSelected;

  const DirectImagePicker({
    super.key,
    this.size = 80.0,
    this.placeholderText,
    this.onImageSelected,
  });

  @override
  State<DirectImagePicker> createState() => _DirectImagePickerState();
}

class _DirectImagePickerState extends State<DirectImagePicker> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImageFromGallery,
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

  Future<void> _pickImageFromGallery() async {
    try {
      final imagePicker = ImagePickerService();
      final selectedFile = await imagePicker.pickImageFromGallery(context);
      
      if (selectedFile != null) {
        setState(() {
          _selectedImage = selectedFile;
        });
        widget.onImageSelected?.call(selectedFile);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
