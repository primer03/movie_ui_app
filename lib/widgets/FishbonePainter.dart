import 'package:flutter/material.dart';

class FishbonePainter extends CustomPainter {
  final Color color;

  FishbonePainter({this.color = Colors.red});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // สร้าง Path สำหรับฟันปลา
    Path path = Path();
    double width = size.width;
    double height = size.height;
    double step = 14; // ระยะห่างระหว่างฟันปลา
    double fishBoneWidth = 5; // ความกว้างของฟันปลา
    double fishBoneHeight = 10; // ความสูงของฟันปลา

    // วาดฟันปลา
    for (double i = 0; i < height; i += step) {
      path.moveTo(width, i); // เริ่มที่มุมขวาบน
      path.lineTo(width - fishBoneWidth, i + (fishBoneHeight / 2)); // ฟันปลา
      path.lineTo(width, i + fishBoneHeight); // กลับไปที่มุมขวา
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
