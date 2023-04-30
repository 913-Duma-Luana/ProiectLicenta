import 'dart:ui';
import 'package:project_luana_v1/level_map_package/src/enum/image_side_enum.dart';

class ImageParams {
  final Function(int)? onTap;
  final String path;
  final Size size;

  /// Default is 0.6
  final double imagePositionFactor;

  /// TIP: Try to assign a value which is a factor of [LevelMapParams.levelCount]. It helps to equally distribute the images.
  final double repeatCountPerLevel;

  /// If an image need to be painted only on left or right to the path, set this parameter.
  final Side side;

  final bool isTappableLevel; // Add this line

  ImageParams({
    this.onTap,
    required this.path,
    required this.size,
    this.imagePositionFactor = 0.4,
    this.repeatCountPerLevel = 0.5,
    this.side = Side.BOTH,
    this.isTappableLevel = false, // Add this line
  })  : assert(imagePositionFactor >= 0 && imagePositionFactor <= 1,
            "Image Position factor should be between 0 and 1"),
        assert(repeatCountPerLevel >= 0,
            "repeatPerLevel parameter should be positive");
}
