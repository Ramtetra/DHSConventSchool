import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerResult {
  final File file;
  final String base64;

  ImagePickerResult({
    required this.file,
    required this.base64,
  });
}

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<ImagePickerResult?> pickFromCamera() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return null;

    return _processAndCompress(pickedFile);
  }

  static Future<ImagePickerResult?> pickFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    return _processAndCompress(pickedFile);
  }

  /// 🔥 Resize + Compress to ~200KB
  static Future<ImagePickerResult> _processAndCompress(
      XFile pickedFile) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Try with decreasing quality until under 200KB
    int quality = 85;
    File? compressedFile;

    while (quality >= 40) {
      final result = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: quality,
        minWidth: 800,   // resize width
        minHeight: 800,  // resize height
        format: CompressFormat.jpeg,
      );

      if (result == null) break;

      final file = File(result.path);
      final sizeInKB = await file.length() / 1024;

      if (sizeInKB <= 200) {
        compressedFile = file;
        break;
      }

      quality -= 10; // reduce quality and retry
    }

    compressedFile ??= File(pickedFile.path); // fallback

    final bytes = await compressedFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    debugPrint('Final image size: ${(bytes.length / 1024).toStringAsFixed(1)} KB');

    return ImagePickerResult(
      file: compressedFile,
      base64: base64Image,
    );
  }
}
