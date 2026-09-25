import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  static const ink = Color(0xFF0C0A18);
  static const inkSoft = Color(0xFF141125);
  static const surface = Color(0xFF1B1730);
  static const surfaceRaised = Color(0xFF252041);
  static const lavender = Color(0xFFBBA5FF);
  static const lilac = Color(0xFFE4D7FF);
  static const pink = Color(0xFFF59BC3);
  static const coral = Color(0xFFFFB184);
  static const mint = Color(0xFF9BE7D8);
  static const yellow = Color(0xFFFFD47E);
  static const text = Color(0xFFF8F5FF);
  static const muted = Color(0xFFA9A3BC);
  static const line = Color(0xFF332E4E);
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.lavender,
    brightness: Brightness.dark,
    surface: AppColors.ink,
  );

  return base.copyWith(
    colorScheme: scheme.copyWith(
      primary: AppColors.lavender,
      onPrimary: AppColors.ink,
      secondary: AppColors.pink,
      onSecondary: AppColors.ink,
      surface: AppColors.ink,
      onSurface: AppColors.text,
    ),
    scaffoldBackgroundColor: AppColors.ink,
    canvasColor: AppColors.ink,
    splashFactory: InkSparkle.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
      },
    ),
    textTheme: base.textTheme.copyWith(
      displayLarge: const TextStyle(
        color: AppColors.text,
        fontSize: 38,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.3,
        height: 1.05,
      ),
      displayMedium: const TextStyle(
        color: AppColors.text,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.9,
        height: 1.08,
      ),
      headlineSmall: const TextStyle(
        color: AppColors.text,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: const TextStyle(
        color: AppColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: const TextStyle(
        color: AppColors.text,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: const TextStyle(
        color: AppColors.text,
        fontSize: 16,
        height: 1.45,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.muted,
        fontSize: 14,
        height: 1.4,
      ),
      labelLarge: const TextStyle(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      labelMedium: const TextStyle(
        color: AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.muted),
      labelStyle: const TextStyle(color: AppColors.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.lavender, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.coral),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.coral, width: 1.3),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.inkSoft,
      indicatorColor: AppColors.lavender,
      height: 72,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        final selected = states.contains(MaterialState.selected);
        return TextStyle(
          color: selected ? AppColors.lilac : AppColors.muted,
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        final selected = states.contains(MaterialState.selected);
        return IconThemeData(
          color: selected ? AppColors.ink : AppColors.muted,
          size: 22,
        );
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.lavender,
      disabledColor: AppColors.surface,
      side: const BorderSide(color: AppColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      labelStyle: const TextStyle(color: AppColors.text, fontSize: 12),
      secondaryLabelStyle: const TextStyle(color: AppColors.ink, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    ),
  );
}

class FandomPageRoute<T> extends PageRouteBuilder<T> {
  FandomPageRoute({required Widget child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 520),
          reverseTransitionDuration: const Duration(milliseconds: 360),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.055, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

class StaggeredEntry extends StatelessWidget {
  const StaggeredEntry({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.07),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        final eased = Curves.easeOutCubic.transform(value);
        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - eased) * 100, offset.dy * (1 - eased) * 100),
            child: child,
          ),
        );
      },
    );
  }
}
