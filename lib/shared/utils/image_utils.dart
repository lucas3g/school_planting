import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;

Future<File> compressImage(File file, {int quality = 80}) {
  return Isolate.run(() {
    final bytes = file.readAsBytesSync();

    final image = img.decodeImage(bytes);

    if (image == null) return file;

    final compressedBytes = img.encodeJpg(image, quality: quality);

    return file..writeAsBytesSync(compressedBytes);
  });
}
