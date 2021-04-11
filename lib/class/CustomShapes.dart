import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glm_mobile/utilities/constants.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 2.5);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1, size.width, size.height / 2.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class HomeCurvedShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [
          0.2,
          0.4,
          0.7,
        ],
        colors: [
          Color(0xff1C82C3),
          Color(0x831c82c3),
          Color(0x371c82c3),
          // Color(0xffc3991c),
          // Color(0x80c3991c),
          // Color(0x80c3991c),
        ]);
    // paint.color = Color(0xffd4d3fd);
    var paint = Paint()..shader = gradient.createShader(rect);

    var path = Path();
    path.lineTo(0, size.height / 2.5);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1, size.width, size.height / 2.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawShadow(path, Colors.black, 04, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}