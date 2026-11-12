import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../onboarding/entrepreneur_profile_screen.dart';
import 'rural_auth_shell.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  bool loading = false;
  bool hidePassword = true;

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      message('Please complete all fields.');
      return;
    }
    if (password.length < 6) {
      message('Password must contain at least 6 characters.');
      return;
    }
    if (password != confirmPasswordController.text) {
      message('Passwords do not match.');
      return;
    }
    setState(() => loading = true);
    try {
      await authService.signUp(
        fullName: name,
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const EntrepreneurProfileScreen()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        message('An account already exists with this email.');
      } else if (e.code == 'invalid-email') {
        message('Please enter a valid email address.');
      } else if (e.code == 'weak-password') {
        message('Please choose a stronger password.');
      } else {
        message(e.message ?? 'Could not create account.');
      }
    } catch (_) {
      message('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RuralAuthShell(
      title: 'Create your account',
      subtitle: 'Turn your business idea into something real.',
      showBack: true,
      fields: [
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: ruralInput('Full name', Icons.person_outline),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: ruralInput('Email address', Icons.email_outlined),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: hidePassword,
          textInputAction: TextInputAction.next,
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
        const SizedBox(height: 14),
        TextField(
          controller: confirmPasswordController,
          obscureText: hidePassword,
          onSubmitted: (_) => loading ? null : createAccount(),
          decoration: ruralInput(
            'Confirm password',
            Icons.verified_user_outlined,
          ),
        ),
        const SizedBox(height: 22),
        ruralPrimaryButton(
          label: 'Create Account',
          loading: loading,
          onPressed: createAccount,
        ),
      ],
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Already have an account?'),
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text(
              'Login',
              style: TextStyle(color: ruralForest, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
