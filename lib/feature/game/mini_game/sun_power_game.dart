import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SunPowerGame extends StatefulWidget {
  const SunPowerGame({super.key});

  @override
  State<SunPowerGame> createState() => _SunPowerGameState();
}

class _SunPowerGameState extends State<SunPowerGame> {
  List<List<Offset>> _points = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build (@오종현)
    // TODO: 게임 종료 시 navigator.pop 으로 결과 bool 로 넘겨주기
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100, minHeight: 75),
      child: Stack(
        children: [
          Image.asset("assets/images/minigame/pop up.jpg"),
          Image.asset("assets/images/minigame/sun/sun.png"),
          Stack(
            children: [
              Positioned(
                left: 136.w,
                top: 36.h,
                child: SizedBox(
                  width: 184.w,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      width: 188.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/minigame/sun/dirt.png"),
                          fit: BoxFit.contain
                        )
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 136.w,
                top: 36.h,
                child: SizedBox(
                  width: 184.w,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(184.w, 141.h),
                          painter: DrawingPainter(points: _points),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onPanStart: (details) {
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
                          onPanEnd: (details) {
                        
                          },
                          child: CustomPaint(
                            painter: DrawingPainter(points: _points),
                            size: Size.infinite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void drawStrat(Offset offset) {
    List oneLine = [];

  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.points});
  
  final List<List<Offset>> points;

  @override
  void paint(Canvas canvas, Size size) {
    for(List<Offset> point in points) {
      Color color = Colors.red;
      double size = 20.w;
      final p = Path();
      p.addPolygon(point, false);
      canvas.drawPath(p, Paint()..color = color..strokeWidth=size..strokeCap=StrokeCap.round..style=PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}