import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';


class SabiosSymbolPainter extends CustomPainter {
  final Color color;

  const SabiosSymbolPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scaleX = size.width / 24.0;
    final scaleY = size.height / 24.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);


    final path1 = Path();
    path1.moveTo(5, 19);
    path1.cubicTo(10, 18, 13, 15, 14, 10);
    path1.cubicTo(16, 14, 15, 18, 12, 21);

    path1.moveTo(7, 16);
    path1.cubicTo(4, 12, 5, 7, 10, 4);
    path1.cubicTo(10.5, 8, 12.5, 10, 16, 11);

    canvas.drawPath(path1, paint);


    final path2 = Path();
    path2.moveTo(6, 20);
    path2.lineTo(18, 20);
    canvas.drawPath(path2, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SabiosSymbolPainter oldDelegate) =>
      oldDelegate.color != color;
}


class BrandLogo extends StatelessWidget {
  final double emblemSize;
  final double fontSize;
  final bool isLight;
  final VoidCallback? onTap;

  const BrandLogo({
    super.key,
    this.emblemSize = 40,
    this.fontSize = 25,
    this.isLight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: emblemSize,
          height: emblemSize,
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.primaryTeal,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: emblemSize * 0.58,
            height: emblemSize * 0.58,
            child: CustomPaint(
              painter: SabiosSymbolPainter(
                color: isLight ? AppColors.primaryTeal : AppColors.accentGold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'sábios',
          style: AppTextStyles.brandLogo.copyWith(
            fontSize: fontSize,
            color: isLight ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
