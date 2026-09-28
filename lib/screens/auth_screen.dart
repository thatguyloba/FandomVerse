import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_logo.dart';
import '../widgets/fandom_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.app});

  final AppController app;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final Set<String> _interests = {'Anime'};

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // EMAIL/PASSWORD SIGN UP / LOGIN
  Future<void> _submit() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      UserCredential credential;

      if (_isSignUp) {
        credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = credential.user;
        if (user != null) {
          final displayName = _nameController.text.trim();

          await user.updateDisplayName(displayName);

          try {
            await _firestore.collection('users').doc(user.uid).set({
              'displayName': displayName,
              'email': _emailController.text.trim(),
              'interests': _interests.toList(),
              'createdAt': FieldValue.serverTimestamp(),
              'provider': 'password',
            }, SetOptions(merge: true));
          } catch (e, st) {
            // ignore: avoid_print
            print('Firestore error during sign-up: $e\n$st');
          }
        }
      } else {
        credential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (!mounted) return;

      final user = credential.user;
      widget.app.signIn(
        name: user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!
            : (_nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : _emailController.text.trim()),
      );
    } on FirebaseAuthException catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print(
        'FirebaseAuthException during ${_isSignUp ? 'sign-up' : 'login'}: '
        'code=${e.code}, message=${e.message}\n$st',
      );

      String message = 'Authentication failed';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'That email is already registered.';
          break;
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        case 'weak-password':
          message = 'Password should be at least 6 characters.';
          break;
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          message =
              'Email/password sign-in is disabled. Enable it in Firebase Console > Authentication.';
          break;
        default:
          message = e.message ?? message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print('Unexpected error during auth: $e\n$st');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // GOOGLE SIGN-IN
  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final googleSignIn = GoogleSignIn(
        clientId: kIsWeb
            ? '551155728334-lelnrb1g3l9hgn3lejhhpabnb2ej3ifv.apps.googleusercontent.com'
            : null,
        scopes: ['email'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled — no error needed
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null &&
          userCredential.additionalUserInfo?.isNewUser == true) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': user.displayName ?? googleUser.displayName ?? '',
            'email': user.email,
            'interests': _interests.toList(),
            'createdAt': FieldValue.serverTimestamp(),
            'provider': 'google',
          }, SetOptions(merge: true));
        } catch (e, st) {
          // ignore: avoid_print
          print('Firestore error (Google): $e\n$st');
        }
      }

      if (!mounted) return;
      widget.app.signIn(
        name: user?.displayName ?? user?.email ?? 'Google fan',
      );
    } on FirebaseAuthException catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print('FirebaseAuthException during Google sign-in: '
          'code=${e.code}, message=${e.message}\n$st');

      String message = 'Google sign-in failed';
      if (e.code == 'account-exists-with-different-credential') {
        message =
            'An account already exists with the same email but different sign-in method.';
      } else if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print('Unexpected error during Google sign-in: $e\n$st');

      String message = 'Could not sign in with Google.';
      final errorText = e.toString();

      if (errorText.contains('popup_closed')) {
        message =
            'Google sign-in popup closed unexpectedly. This often happens if:\n'
            '• Your browser blocked the popup\n'
            '• The authorized origin/port isn\'t saved yet in Google Cloud Console\n'
            '• Third-party cookies are blocked\n\n'
            'Try again in a moment, or check pop-up blocker settings.';
      } else if (errorText.contains('origin_mismatch')) {
        message =
            'This origin is not authorized in Google Cloud Console. '
            'Add it under Authorized JavaScript origins.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // APPLE SIGN-IN (iOS/macOS mainly)
  Future<void> _signInWithApple() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      String? fullName;
      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        fullName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
      }

      if (user != null &&
          fullName != null &&
          fullName.isNotEmpty &&
          (user.displayName == null || user.displayName!.isEmpty)) {
        await user.updateDisplayName(fullName);
      }

      if (user != null &&
          userCredential.additionalUserInfo?.isNewUser == true) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': fullName ?? user.displayName ?? '',
            'email': user.email,
            'interests': _interests.toList(),
            'createdAt': FieldValue.serverTimestamp(),
            'provider': 'apple',
          }, SetOptions(merge: true));
        } catch (e, st) {
          // ignore: avoid_print
          print('Firestore error (Apple): $e\n$st');
        }
      }

      if (!mounted) return;
      widget.app.signIn(
        name: fullName ?? user?.displayName ?? user?.email ?? 'Apple fan',
      );
    } on SignInWithAppleAuthorizationException catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print(
          'SignInWithAppleAuthorizationException: code=${e.code}, message=${e.message}\n$st');

      if (e.code == AuthorizationErrorCode.canceled) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apple sign-in failed.'),
        ),
      );
    } on FirebaseAuthException catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print('FirebaseAuthException during Apple sign-in: '
          'code=${e.code}, message=${e.message}\n$st');

      String message = 'Apple sign-in failed';
      if (e.code == 'account-exists-with-different-credential') {
        message =
            'An account already exists with the same email but different sign-in method.';
      } else if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e, st) {
      if (!mounted) return;

      // ignore: avoid_print
      print('Unexpected error during Apple sign-in: $e\n$st');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not sign in with Apple.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // PASSWORD RESET (EMAIL)
  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email above first.')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to send reset email.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send reset email.'),
        ),
      );
    }
  }

  // ANONYMOUS / GUEST SIGN-IN
  Future<void> _signInAsGuest() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _auth.signInAnonymously();

      if (!mounted) return;

      widget.app.signIn(
        name: 'Guest fan',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Could not sign in as guest.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not sign in as guest.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setMode(bool signUp) {
    if (_isSignUp == signUp) return;
    setState(() {
      _isSignUp = signUp;
      _formKey.currentState?.reset();
      _nameController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isApplePlatform =
        Theme.of(context).platform == TargetPlatform.iOS ||
            Theme.of(context).platform == TargetPlatform.macOS;

    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: FandomLogo(size: 58, showWordmark: true),
                    ),
                    const SizedBox(height: 42),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 360),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.06, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: Column(
                        key: ValueKey(_isSignUp),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isSignUp
                                ? 'Build your universe.'
                                : 'Welcome back, fan.',
                            style:
                                Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isSignUp
                                ? 'Pick a few interests and we will tune the feed to you.'
                                : 'Your saved worlds, fresh drops and fandom people are waiting.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          _ModeButton(
                            label: 'Log in',
                            selected: !_isSignUp,
                            onTap: () => _setMode(false),
                          ),
                          _ModeButton(
                            label: 'Create account',
                            selected: _isSignUp,
                            onTap: () => _setMode(true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Form(
                      key: _formKey,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 340),
                        curve: Curves.easeOutCubic,
                        child: Column(
                          key: ValueKey(_isSignUp),
                          children: [
                            if (_isSignUp) ...[
                              TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'What should we call you?',
                                  prefixIcon:
                                      Icon(Icons.person_outline_rounded),
                                ),
                                validator: (value) {
                                  if (_isSignUp &&
                                      (value == null ||
                                          value.trim().length < 2)) {
                                    return 'Enter at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                            ],
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email address',
                                hintText: 'you@example.com',
                                prefixIcon: Icon(
                                  Icons.alternate_email_rounded,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || !value.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'At least 6 characters',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword =
                                        !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Use at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            if (_isSignUp) ...[
                              const SizedBox(height: 22),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Tune your feed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              const SizedBox(height: 11),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    'Anime',
                                    'Gaming',
                                    'Comics',
                                    'Movies',
                                    'TV Shows',
                                    'Manga',
                                  ].map((interest) {
                                    final selected =
                                        _interests.contains(interest);
                                    return FilterChip(
                                      selected: selected,
                                      label: Text(interest),
                                      avatar: Icon(
                                        selected
                                            ? Icons.check_rounded
                                            : Icons.add_rounded,
                                        size: 15,
                                        color: selected
                                            ? AppColors.ink
                                            : AppColors.muted,
                                      ),
                                      onSelected: (value) {
                                        setState(() {
                                          if (value) {
                                            _interests.add(interest);
                                          } else {
                                            _interests.remove(interest);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _submit,
                                child: AnimatedSwitcher(
                                  duration: const Duration(
                                      milliseconds: 200),
                                  child: _isLoading
                                      ? const SizedBox(
                                          key: ValueKey('loading'),
                                          width: 21,
                                          height: 21,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                          ),
                                        )
                                      : Text(
                                          _isSignUp
                                              ? 'Enter the verse'
                                              : 'Continue',
                                          key: const ValueKey('label'),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!_isSignUp) ...[
                      const SizedBox(height: 13),
                      Center(
                        child: TextButton(
                          onPressed: _sendPasswordReset,
                          child: const Text('Forgot your password?'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 19),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.line.withOpacity(0.8),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.line.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 19),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text('Continue with Google'),
                      ),
                    ),

                    if (isApplePlatform) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _signInWithApple,
                          icon: const Icon(Icons.apple),
                          label: const Text('Continue with Apple'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _signInAsGuest,
                        icon: const Icon(Icons.explore_rounded),
                        label: const Text('Explore as a guest'),
                      ),
                    ),

                    const SizedBox(height: 25),
                    const Center(
                      child: Text(
                        'By continuing, you agree to our community guidelines.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? AppColors.lavender : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? AppColors.ink : AppColors.muted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}