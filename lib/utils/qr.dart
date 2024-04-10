

import 'package:zxing2/qrcode.dart';
import "package:image/image.dart" as img;
import 'dart:typed_data';

Future<Uint8List> qrEncodeToBytes(String text) async {
  var qrcode = Encoder.encode(text, ErrorCorrectionLevel.h);
  var matrix = qrcode.matrix!;
  var scale = 10;
  var width = matrix.width * scale;
  var height = matrix.height * scale;

  img.Image image = img.Image(
    width: width + 200,
    height: height + 200,
  );
  img.fill(image, color: img.ColorRgba8(255, 255, 255, 0xFF));

  var xs = [];
  for (var x = 0; x < matrix.width; x++) {
    for (var y = 0; y < matrix.height; y++) {
      if (matrix.get(x, y) == 1) {
        xs.add([x + 10, y + 10]);
      }
    }
  }

  for (var i = 0; i < xs.length; i++) {
    var x = xs[i][0];
    var y = xs[i][1];

    img.fillRect(
      image,
      x1: x * scale,
      y1: y * scale,
      x2: x * scale + scale,
      y2: y * scale + scale,
      color: img.ColorRgba8(0, 0, 0, 0xFF),
    );
  }
  return img.encodePng(image);
  // var pngBytes = img.encodePng(image);
  // await File(path).writeAsBytes(pngBytes);
  // return path;
}
