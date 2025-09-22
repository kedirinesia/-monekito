import 'dart:io';

class ImageUtils {
  /// Extract image path from transaction notes
  static String? getImagePathFromNotes(String? notes) {
    if (notes == null || notes.isEmpty) return null;
    
    if (notes.startsWith('IMAGE_PATH:')) {
      final path = notes.substring('IMAGE_PATH:'.length);
      // Check if the file still exists
      final file = File(path);
      if (file.existsSync()) {
        return path;
      }
    }
    
    return null;
  }
  
  /// Check if notes contains an image path
  static bool hasImagePath(String? notes) {
    return getImagePathFromNotes(notes) != null;
  }
  
  /// Get clean notes without image path
  static String? getCleanNotes(String? notes) {
    if (notes == null || notes.isEmpty) return null;
    
    if (notes.startsWith('IMAGE_PATH:')) {
      return null; // This means the notes field only contains image path
    }
    
    return notes;
  }
}
