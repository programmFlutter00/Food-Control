import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> pickImageFromGallery() async {
  final permission = await Permission.photos.request();

  if (!permission.isGranted) {
    return null;
  }

  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return null;

  return File(pickedFile.path);
}
