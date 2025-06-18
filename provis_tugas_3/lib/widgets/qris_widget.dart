import 'package:flutter/material.dart';

class QRISWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const QRISWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      height: height ?? 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Simple QR Code representation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: CustomPaint(
              painter: SimpleQRPainter(),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'QRIS Payment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Scan untuk membayar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleQRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final squareSize = size.width / 8;

    // Create simple QR-like pattern
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              i * squareSize,
              j * squareSize,
              squareSize,
              squareSize,
            ),
            paint,
          );
        }
      }
    }

    // Add corner squares (typical QR code markers)
    final cornerSize = squareSize * 2;
    
    // Top-left corner
    canvas.drawRect(Rect.fromLTWH(0, 0, cornerSize, cornerSize), paint);
    canvas.drawRect(
      Rect.fromLTWH(squareSize * 0.3, squareSize * 0.3, 
                   cornerSize * 0.4, cornerSize * 0.4),
      Paint()..color = Colors.white,
    );

    // Top-right corner
    canvas.drawRect(
      Rect.fromLTWH(size.width - cornerSize, 0, cornerSize, cornerSize),
      paint,
    );
    
    // Bottom-left corner
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - cornerSize, cornerSize, cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
