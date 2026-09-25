import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FandomLogo extends StatelessWidget {
  const FandomLogo({
    super.key,
    this.size = 52,
    this.showWordmark = false,
    this.light = false,
  });

  final double size;
  final bool showWordmark;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final mark = CustomPaint(
      size: Size.square(size),
      painter: FandomMarkPainter(),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FANDOM',
              style: TextStyle(
                color: light ? AppColors.text : AppColors.text,
                fontSize: size * 0.29,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
                height: 0.9,
              ),
            ),
            Text(
              'VERSE',
              style: TextStyle(
                color: AppColors.lavender,
                fontSize: size * 0.24,
                fontWeight: FontWeight.w800,
                letterSpacing: 3.8,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FandomMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final rect = Offset.zero & size;
    final radius = Radius.circular(s * 0.29);

    final background = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFBCA4FF), Color(0xFFF392C0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), background);

    final inner = Paint()..color = const Color(0xFF17122B).withOpacity(0.86);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.095, s * 0.095, s * 0.81, s * 0.81),
        Radius.circular(s * 0.23),
      ),
      inner,
    );

    final orbit = Paint()
      ..color = const Color(0xFFDCCFFF).withOpacity(0.57)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.024;
    final orbitRect = Rect.fromLTWH(s * 0.19, s * 0.28, s * 0.62, s * 0.43);
    canvas.save();
    canvas.rotate(-0.25);
    canvas.drawArc(orbitRect, math.pi * 0.05, math.pi * 1.72, false, orbit);
    canvas.restore();

    final core = Paint()..color = AppColors.lavender;
    final center = Offset(s * 0.5, s * 0.5);
    final star = Path();
    for (var i = 0; i < 16; i++) {
      final angle = -math.pi / 2 + (math.pi * i / 8);
      final radius = i.isEven ? s * 0.22 : s * 0.075;
      final point = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      if (i == 0) {
        star.moveTo(point.dx, point.dy);
      } else {
        star.lineTo(point.dx, point.dy);
      }
    }
    star.close();
    canvas.drawPath(star, core);

    final dot = Paint()..color = AppColors.coral;
    canvas.drawCircle(Offset(s * 0.77, s * 0.27), s * 0.055, dot);
    final shine = Paint()..color = Colors.white.withOpacity(0.8);
    canvas.drawCircle(Offset(s * 0.36, s * 0.34), s * 0.018, shine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          right: -100,
          child: _Glow(size: 300, color: AppColors.lavender.withOpacity(0.10)),
        ),
        Positioned(
          bottom: -150,
          left: -120,
          child: _Glow(size: 350, color: AppColors.pink.withOpacity(0.07)),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}
