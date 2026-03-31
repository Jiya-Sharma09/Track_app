import 'package:flutter/material.dart';

class TopLeftCurve extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);

    path.quadraticBezierTo(size.width*0.75, size.height + 10, size.width*0.75, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}