import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorGenerator {
  static Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return HSLColor.fromColor(paletteGenerator.dominantColor!.color)
        .withLightness(0.6)
        .toColor();
  }
}
