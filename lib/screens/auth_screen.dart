import 'dart:async';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    widget.app.signIn(name: _isSignUp ? _nameController.text : null);
  }

  void _setMode(bool signUp) {
    if (_isSignUp == signUp) return;
    setState(() {
      _isSignUp = signUp;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    const Center(child: FandomLogo(size: 58, showWordmark: true)),
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
                            _isSignUp ? 'Build your universe.' : 'Welcome back, fan.',
                            style: Theme.of(context).textTheme.displayMedium,
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
                          _ModeButton(label: 'Log in', selected: !_isSignUp, onTap: () => _setMode(false)),
                          _ModeButton(label: 'Create account', selected: _isSignUp, onTap: () => _setMode(true)),
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
                                  labelText: 'Display name',
                                  hintText: 'What should we call you?',
                                  prefixIcon: Icon(Icons.person_outline_rounded),
                                ),
                                validator: (value) {
                                  if (_isSignUp && (value == null || value.trim().length < 2)) {
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
                                prefixIcon: Icon(Icons.alternate_email_rounded),
                              ),
                              validator: (value) {
                                if (value == null || !value.contains('@')) return 'Enter a valid email';
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
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) return 'Use at least 6 characters';
                                return null;
                              },
                            ),
                            if (_isSignUp) ...[
                              const SizedBox(height: 22),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Tune your feed', style: Theme.of(context).textTheme.titleMedium),
                              ),
                              const SizedBox(height: 11),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: ['Anime', 'Gaming', 'Comics', 'Movies'].map((interest) {
                                    final selected = _interests.contains(interest);
                                    return FilterChip(
                                      selected: selected,
                                      label: Text(interest),
                                      avatar: Icon(
                                        selected ? Icons.check_rounded : Icons.add_rounded,
                                        size: 15,
                                        color: selected ? AppColors.ink : AppColors.muted,
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
                                  duration: const Duration(milliseconds: 200),
                                  child: _isLoading
                                      ? const SizedBox(
                                          key: ValueKey('loading'),
                                          width: 21,
                                          height: 21,
                                          child: CircularProgressIndicator(strokeWidth: 2.2),
                                        )
                                      : Text(
                                          _isSignUp ? 'Enter the verse' : 'Continue',
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
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset flow is ready for Firebase Auth.')),
                          ),
                          child: const Text('Forgot your password?'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 19),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.line.withOpacity(0.8))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text('OR', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                        ),
                        Expanded(child: Divider(color: AppColors.line.withOpacity(0.8))),
                      ],
                    ),
                    const SizedBox(height: 19),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () => widget.app.signIn(name: 'Guest fan'),
                        icon: const Icon(Icons.explore_rounded),
                        label: const Text('Explore as a guest'),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Center(
                      child: Text(
                        'By continuing, you agree to our community guidelines.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: AppColors.muted),
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
  const _ModeButton({required this.label, required this.selected, required this.onTap});

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
