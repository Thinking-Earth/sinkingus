import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'dart:ui' as ui;

import 'package:sinking_us/helpers/constants/app_typography.dart';

class SunPowerGame extends StatefulWidget {
  const SunPowerGame({super.key});

  @override
  State<SunPowerGame> createState() => _SunPowerGameState();
}

class _SunPowerGameState extends State<SunPowerGame> {
  List<List<Offset>> _points = [];
  late ui.Image _drawedImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawingPainter = DrawingPainter(points: _points, image: _drawedImage);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100, minHeight: 75),
      child: Stack(
        children: [
          Image.asset("assets/images/minigame/pop up.jpg"),
          Image.asset("assets/images/minigame/sun/sun.png"),
          Image.asset("assets/images/minigame/xBtn.png"),
          Stack(
            children: [
              Positioned(
                left: 136.w,
                top: 36.h,
                child: SizedBox(
                  width: 184.w,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onPanStart: (details) {
                            print("eeeee");
                            setState(() {
                              final oneLine = <Offset>[];
                              oneLine.add(details.localPosition);
                              _points.add(oneLine);
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              _points.last.add(details.localPosition);
                            });
                          },
                          child: CustomPaint(
                            painter: drawingPainter,
                            size: Size.infinite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 50.w,
                bottom: 24.h,
                width: 362.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(tr("sun_power"),
                            textStyle: AppTypography.whitePixel)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 0.w,
            top: 0.w,
            child: GestureDetector(
              onTap: () {
                if (drawingPainter.percentage >= 100) {
                  AppRouter.pop(true);
                } else {
                  AppRouter.pop(false);
                }
              },
              child: Container(
                width: 40.w,
                height: 40.w,
                color: Colors.transparent,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _loadImage() async {
    const image = AssetImage("assets/images/minigame/sun/dirt.png");
    final completer = Completer<ImageInfo>();
    image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info),
            onError: (dynamic exception, StackTrace? stackTrace) {
              completer.completeError(exception);
            },
          ),
        );
    final info = await completer.future;
    final imageByteData =
        await info.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = imageByteData!.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(uint8List);
    final frameInfo = await codec.getNextFrame();
    _drawedImage = frameInfo.image;
    setState(() {});
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.points, required this.image});

  final List<List<Offset>> points;
  final ui.Image image;
  double drawnArea = 0.0;
  double percentage = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw image with clear blending mode
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final offset = Offset((size.width - imageSize.width) / 2,
        (size.height - imageSize.height) / 2);
    canvas.drawImage(image, offset, Paint());
    // Calculate percentage of drawing
    double totalArea = size.width * size.height;

    // Draw points with srcIn blending mode
    for (List<Offset> point in points) {
      Color color = Colors.black; // Adjust the color as needed
      double size = 30.w; // Adjust the size of the stroke as needed
      final p = Path();
      p.addPolygon(point, false);
      canvas.drawPath(
          p,
          Paint()
            ..color = color
            ..strokeWidth = size
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..blendMode = BlendMode.srcIn);

      // Calculate drawn area
      drawnArea += _calculatePathArea(p);
      // Calculate percentage
      percentage = (drawnArea / totalArea) * 100;
    }

    // Restore to default blending mode
    canvas.restore();
  }

  double _calculatePathArea(Path path) {
    Rect bounds = path.getBounds();
    return bounds.width * bounds.height;
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}
