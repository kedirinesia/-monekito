import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/core/services/image_picker_service.dart';

class ImageSelectorWidget extends StatelessWidget {
  final File? selectedImage;
  final String? defaultAssetPath;
  final double size;
  final VoidCallback? onImageChanged;
  final String? placeholderText;

  const ImageSelectorWidget({
    super.key,
    this.selectedImage,
    this.defaultAssetPath,
    this.size = 80.0,
    this.onImageChanged,
    this.placeholderText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePicker(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: _buildImageContent(context),
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else if (defaultAssetPath != null) {
      return Image.asset(
        defaultAssetPath!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: size * 0.3,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            if (placeholderText != null)
              Text(
                placeholderText!,
                style: TextStyle(
                  fontSize: size * 0.15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.showImageSourceDialog(context);
    
    if (selectedFile != null && onImageChanged != null) {
      onImageChanged!();
    }
  }
}

class ImageSelectorWithPreview extends StatefulWidget {
  final File? initialImage;
  final String? defaultAssetPath;
  final double size;
  final Function(File?)? onImageSelected;
  final String? placeholderText;

  const ImageSelectorWithPreview({
    super.key,
    this.initialImage,
    this.defaultAssetPath,
    this.size = 80.0,
    this.onImageSelected,
    this.placeholderText,
  });

  @override
  State<ImageSelectorWithPreview> createState() => _ImageSelectorWithPreviewState();
}

class _ImageSelectorWithPreviewState extends State<ImageSelectorWithPreview> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageSelectorWidget(
          selectedImage: _selectedImage,
          defaultAssetPath: widget.defaultAssetPath,
          size: widget.size,
          placeholderText: widget.placeholderText,
          onImageChanged: _handleImageChanged,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _removeImage,
                icon: const Icon(Icons.delete),
                label: const Text('Remove'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.pickImageFromGallery(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
      widget.onImageSelected?.call(selectedFile);
    }
  }

  Future<void> _takePhoto() async {
    final imagePicker = ImagePickerService();
    final selectedFile = await imagePicker.pickImageFromCamera(context);
    
    if (selectedFile != null) {
      setState(() {
        _selectedImage = selectedFile;
      });
      widget.onImageSelected?.call(selectedFile);
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected?.call(null);
  }

  void _handleImageChanged() {
    // This method is called when the image is changed through the ImageSelectorWidget
    // The actual image selection is handled by the individual methods above
  }
}
