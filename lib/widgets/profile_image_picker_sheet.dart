import 'package:flutter/material.dart';
import 'image_picker_service.dart';

typedef OnImagePicked = void Function(ImagePickerResult result);

void showProfileImagePickerSheet({
  required BuildContext context,
  required OnImagePicked onImagePicked,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final result = await ImagePickerService.pickFromCamera();
                if (result != null) {
                  onImagePicked(result);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final result = await ImagePickerService.pickFromGallery();
                if (result != null) {
                  onImagePicked(result);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
