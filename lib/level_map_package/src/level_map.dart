import 'package:flutter/material.dart';
import 'package:project_luana_v1/level_map_package/src/model/images_to_paint.dart';
import 'package:project_luana_v1/level_map_package/src/model/level_map_params.dart';
import 'package:project_luana_v1/level_map_package/src/paint/level_map_painter.dart';
import 'package:project_luana_v1/level_map_package/src/utils/load_ui_image_to_draw.dart';
import 'package:project_luana_v1/level_map_package/src/utils/scroll_behaviour.dart';

class LevelMap extends StatefulWidget {
  final LevelMapParams levelMapParams;
  final Color backgroundColor;

  /// If set to false, scroll starts from the bottom end (level 1).
  final bool scrollToCurrentLevel;

  const LevelMap({
    Key? key,
    required this.levelMapParams,
    this.backgroundColor = Colors.transparent,
    this.scrollToCurrentLevel = true,
  }) : super(key: key);

  @override
  _LevelMapState createState() => _LevelMapState();
}

class _LevelMapState extends State<LevelMap> {
  ImagesToPaint? _imagesToPaint;
  GlobalKey _painterKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    ImagesToPaint? imagesToPaint = await loadImagesToPaint(
      widget.levelMapParams,
      widget.levelMapParams.levelCount,
      widget.levelMapParams.levelHeight,
      MediaQuery
          .of(context)
          .size
          .width,
    );
    setState(() {
      _imagesToPaint = imagesToPaint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          ScrollConfiguration(
            behavior: const MyBehavior(),
            child: SingleChildScrollView(
              controller: ScrollController(
                  initialScrollOffset: (((widget.scrollToCurrentLevel
                      ? (widget.levelMapParams.levelCount -
                      widget.levelMapParams.currentLevel +
                      2)
                      : widget.levelMapParams.levelCount)) *
                      widget.levelMapParams.levelHeight) -
                      constraints.maxHeight),
              child: ColoredBox(
                color: widget.backgroundColor,
                child: GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    if (_imagesToPaint != null) {
                      final RenderBox box = _painterKey.currentContext!
                          .findRenderObject()! as RenderBox;
                      final Offset localOffset = box.globalToLocal(
                          details.globalPosition);
                      final int? level = _imagesToPaint!.findTappedLevel(
                          localOffset);

                      if (level != null) {
                        final imageParams = level <=
                            widget.levelMapParams.currentLevel
                            ? widget.levelMapParams.completedLevelImage
                            : widget.levelMapParams.lockedLevelImage;

                        if (imageParams.isTappableLevel) {
                          imageParams.onTap?.call(level);
                        }
                      }
                    }
                  },
                  child: CustomPaint(
                    key: _painterKey,
                    size: Size(
                      constraints.maxWidth,
                      widget.levelMapParams.levelCount *
                          widget.levelMapParams.levelHeight,
                    ),
                    painter: LevelMapPainter(
                      params: widget.levelMapParams,
                      imagesToPaint: _imagesToPaint,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
