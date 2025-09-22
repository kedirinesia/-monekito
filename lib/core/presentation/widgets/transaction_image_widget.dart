import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/core/utils/image_utils.dart';

class TransactionImageWidget extends StatelessWidget {
  final String? notes;
  final double size;
  final Color? backgroundColor;
  final Widget? fallbackWidget;

  const TransactionImageWidget({
    super.key,
    this.notes,
    this.size = 60.0,
    this.backgroundColor,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = ImageUtils.getImagePathFromNotes(notes);
    
    if (imagePath != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant,
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallback(context);
            },
          ),
        ),
      );
    }
    
    return fallbackWidget ?? _buildFallback(context);
  }
  
  Widget _buildFallback(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Icon(
        Icons.image,
        size: size * 0.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
