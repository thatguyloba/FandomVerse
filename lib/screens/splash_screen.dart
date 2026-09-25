import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _orbitController;
  Timer? _timer;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _timer = Timer(const Duration(milliseconds: 2350), _finish);
  }

  void _finish() {
    if (_hasFinished || !mounted) return;
    _hasFinished = true;
    widget.onFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111027), AppColors.ink, Color(0xFF241936)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -110,
              right: -80,
              child: _SplashGlow(color: AppColors.lavender.withOpacity(0.15)),
            ),
            Positioned(
              bottom: -130,
              left: -100,
              child: _SplashGlow(color: AppColors.pink.withOpacity(0.12)),
            ),
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_pulseController, _orbitController]),
                builder: (context, child) {
                  final pulse = 1 + (_pulseController.value * 0.045);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: pulse,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 146,
                              height: 146,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.lavender.withOpacity(0.22),
                                    AppColors.lavender.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: _orbitController.value * 2 * 3.14159,
                              child: Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.lavender.withOpacity(0.30),
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const FandomLogo(size: 82),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const FandomLogo(size: 48, showWordmark: true),
                      const SizedBox(height: 16),
                      const Text(
                        'Your universe. One place.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: 152,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 2100),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) => LinearProgressIndicator(
                              minHeight: 4,
                              value: value,
                              backgroundColor: Colors.white.withOpacity(0.09),
                              valueColor: const AlwaysStoppedAnimation(AppColors.lavender),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Text(
                'DISCOVER  ·  CONNECT  ·  BELONG',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashGlow extends StatelessWidget {
  const _SplashGlow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}
