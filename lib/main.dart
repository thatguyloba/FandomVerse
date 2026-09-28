import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/app_controller.dart';
import 'screens/app_shell.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before using any Firebase services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FandomVerseApp());
}

class FandomVerseApp extends StatefulWidget {
  const FandomVerseApp({super.key});

  @override
  State<FandomVerseApp> createState() => _FandomVerseAppState();
}

class _FandomVerseAppState extends State<FandomVerseApp> {
  final _app = AppController();
  bool _showSplash = true;

  @override
  void dispose() {
    _app.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _app,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fandom Verse',
          theme: buildAppTheme(),
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 520),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.985, end: 1).animate(animation),
                child: child,
              ),
            ),
            child: _showSplash
                ? SplashScreen(
                    key: const ValueKey('splash'),
                    onFinished: () => setState(() => _showSplash = false),
                  )
                : _app.isAuthenticated
                    ? AppShell(
                        key: const ValueKey('shell'),
                        app: _app,
                      )
                    : AuthScreen(
                        key: const ValueKey('auth'),
                        app: _app,
                      ),
          ),
        );
      },
    );
  }
}