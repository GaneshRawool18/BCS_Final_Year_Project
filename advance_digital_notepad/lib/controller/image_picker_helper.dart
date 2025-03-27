import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    if (await _requestPermission()) {
      // ✅ Check permission first
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path);
      }
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    if (await _requestPermission()) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path);
      }
    }
    return null;
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // ✅ Android 13+ requires READ_MEDIA_IMAGES instead of READ_EXTERNAL_STORAGE
      if (await Permission.photos.isDenied ||
          await Permission.storage.isDenied ||
          await Permission.photos.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied) {
        await [
          Permission.storage,
          Permission.photos,
        ].request();
      }

      var storageStatus = await Permission.storage.status;
      var photosStatus = await Permission.photos.status;

      return storageStatus.isGranted || photosStatus.isGranted;
    } else if (Platform.isIOS) {
      // ✅ Request Photos permission on iOS
      if (await Permission.photos.isDenied) {
        await Permission.photos.request();
      }

      return await Permission.photos.isGranted;
    }

    return false;
  }
}
