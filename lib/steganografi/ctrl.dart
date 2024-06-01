import 'package:image/image.dart' as img;

class Steganography {
  img.Image encodeMessage(img.Image image, String message) {
    List<int> messageBytes = message.codeUnits;
    int messageLength = messageBytes.length;
    int index = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (index < messageLength) {
          int pixel = image.getPixel(x, y);
          int r = img.getRed(pixel);
          int g = img.getGreen(pixel);
          int b = img.getBlue(pixel);

          int diff = (r - g).abs();
          int newDiff = (diff & ~1) | (messageBytes[index] & 1);
          int newR = (r > g) ? g + newDiff : g - newDiff;

          image.setPixel(x, y, img.getColor(newR, g, b));
          index++;
        }
      }
    }
    return image;
  }

  String decodeMessage(img.Image image) {
    List<int> messageBytes = [];
    int messageLength = image.width * image.height;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (messageBytes.length < messageLength) {
          int pixel = image.getPixel(x, y);
          int r = img.getRed(pixel);
          int g = img.getGreen(pixel);

          int diff = (r - g).abs();
          messageBytes.add(diff & 1);
        }
      }
    }

    return String.fromCharCodes(messageBytes);
  }
}
