import 'dart:io';

import 'package:image/image.dart' as img;

Future<File> compressImage(File file, {int quality = 80}) async {
  final bytes = await file.readAsBytes();

  final image = img.decodeImage(bytes);

  if (image == null) return file;

  final compressedBytes = img.encodeJpg(image, quality: quality);

  return file..writeAsBytesSync(compressedBytes);
}
