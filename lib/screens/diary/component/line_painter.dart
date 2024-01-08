import 'package:flutter/material.dart';
import 'dart:math' as math;

//TODO color list에서 스무스하게 넘어지게 구현할 필요

class LinePainter extends CustomPainter {
  final List<Color>? colors;
  final double length;
  final double opacity;

  LinePainter({this.colors, required this.length, required this.opacity});

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawLine(Offset(0, 0), Offset(length, 0), shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawLine(Offset(0, 0), Offset(length, 0), shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawLine(Offset(0, 0), Offset(length, 0), shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    canvas.drawLine(Offset(0, 0), Offset(length * opacity, 0), paint);

    // final gradient1 = new SweepGradient(
    //   tileMode: TileMode.repeated,
    //   colors: [Colors.white, Colors.white],
    // );
    //
    // var cPaint = new Paint();
    // cPaint..shader = gradient1.createShader(rect);
    // cPaint..color = Colors.white;
    // cPaint..strokeWidth = 14 / 2;
    // canvas.save();
    //
    // final centerToCircle = size.width / 2;
    // canvas.save();
    //
    // canvas.translate(centerToCircle, centerToCircle);
    // canvas.rotate(degreeToRadians(angle! + 2));
    //
    // canvas.save();
    // canvas.translate(0.0, -centerToCircle + 14 / 2);
    // canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);
    //
    // canvas.restore();
    // canvas.restore();
    // canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
