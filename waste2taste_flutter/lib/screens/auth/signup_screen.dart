import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../theme.dart';
import '../../widgets/app_button.dart';

/// Signup screen — port of app/signup.tsx.
/// Layout mirrors login: red background with yellow rounded panel.
/// Back button at top instead of BrandMark.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authProvider.notifier)
          .register(_emailController.text.trim(), _passwordController.text);
      if (mounted) context.go('/app/home');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Back button header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 24, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.cream,
                    ),
                  ),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // ── Yellow form panel ─────────────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _AuthInput(
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      _AuthInput(
                        controller: _passwordController,
                        hint: 'Password',
                        obscure: true,
                      ),
                      const SizedBox(height: 12),
                      _AuthInput(
                        controller: _confirmController,
                        hint: 'Confirm Password',
                        obscure: true,
                      ),
                      const SizedBox(height: 12),
                      _AuthInput(
                        controller: _phoneController,
                        hint: 'Phone (optional)',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      if (_loading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.red,
                          ),
                        )
                      else
                        AppButton(
                          label: 'Create Account',
                          onPress: _register,
                        ),
                      const SizedBox(height: 8),
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ────────────────────────────────────────────────────────────

class _AuthInput extends StatelessWidget {
  const _AuthInput({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
