import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'rural_auth_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool loading = false;
  bool hidePassword = true;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showMessage('Please enter your email and password.');
      return;
    }
    setState(() => loading = true);
    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        showMessage('Incorrect email or password.');
      } else if (e.code == 'invalid-email') {
        showMessage('Please enter a valid email address.');
      } else {
        showMessage(e.message ?? 'Login failed.');
      }
    } catch (_) {
      showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RuralAuthShell(
      title: 'Welcome back!',
      subtitle: 'Your business journey continues here.',
      fields: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          decoration: ruralInput('Email address', Icons.email_outlined),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: passwordController,
          obscureText: hidePassword,
          onSubmitted: (_) => loading ? null : login(),
          decoration: ruralInput(
            'Password',
            Icons.lock_outline,
            suffix: IconButton(
              tooltip: hidePassword ? 'Show password' : 'Hide password',
              onPressed: () => setState(() => hidePassword = !hidePassword),
              icon: Icon(
                hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            ),
            child: const Text(
              'Forgot password?',
              style: TextStyle(color: ruralForest),
            ),
          ),
        ),
        ruralPrimaryButton(label: 'Login', loading: loading, onPressed: login),
      ],
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(color: ruralForest, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
