import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/app_colors.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isChecking = false;
  bool _isResending = false;
  bool _isSigningOut = false;
  bool _isVerified = false;
  bool _isNavigating = false;

  String get _email => _auth.currentUser?.email ?? 'your email address';

  @override
  void initState() {
    super.initState();

    _isVerified = _auth.currentUser?.emailVerified ?? false;

    // Check the current verification status when the page opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkVerification(showUnverifiedMessage: false);
      }
    });
  }

  // =====================================================
  // SHOW MESSAGE
  // =====================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // =====================================================
  // NAVIGATE TO HOME
  // =====================================================

  void _goToHome() {
    if (!mounted || _isNavigating) return;

    final user = _auth.currentUser;

    // Only verified users can proceed.
    if (user == null || !user.emailVerified) {
      _showMessage('Please verify your email before continuing.');
      return;
    }

    _isNavigating = true;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  // =====================================================
  // CHECK EMAIL VERIFICATION
  // =====================================================

  Future<void> _checkVerification({bool showUnverifiedMessage = true}) async {
    if (_isChecking || _isNavigating) return;

    setState(() {
      _isChecking = true;
    });

    try {
      final user = _auth.currentUser;

      if (user == null) {
        _showMessage('Your session has expired. Please log in again.');
        return;
      }

      // Refresh user information from Firebase.
      await user.reload();

      final updatedUser = _auth.currentUser;

      if (!mounted) return;

      if (updatedUser?.emailVerified == true) {
        setState(() {
          _isVerified = true;
        });

        _showMessage('Email verified successfully! Welcome to Rural Spark.');

        // Open the dashboard.
        _goToHome();
      } else {
        if (showUnverifiedMessage) {
          _showMessage(
            'Your email is not verified yet. '
            'Please click the verification link sent to your inbox.',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Could not check email verification.');
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  // =====================================================
  // RESEND VERIFICATION EMAIL
  // =====================================================

  Future<void> _resendVerificationEmail() async {
    if (_isResending || _isNavigating) return;

    setState(() {
      _isResending = true;
    });

    try {
      final user = _auth.currentUser;

      if (user == null) {
        _showMessage('Please log in again to resend your verification email.');
        return;
      }

      await user.reload();

      final updatedUser = _auth.currentUser;

      if (!mounted) return;

      if (updatedUser?.emailVerified == true) {
        setState(() {
          _isVerified = true;
        });

        _showMessage('Your email is already verified.');

        _goToHome();
        return;
      }

      await updatedUser!.sendEmailVerification();

      _showMessage(
        'Verification email sent successfully! '
        'Please check your inbox or spam folder.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        _showMessage('Too many requests. Please wait before trying again.');
      } else {
        _showMessage(e.message ?? 'Unable to resend verification email.');
      }
    } catch (_) {
      _showMessage('Unable to send verification email. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  // =====================================================
  // BACK TO LOGIN
  // =====================================================

  Future<void> _backToLogin() async {
    if (_isSigningOut) return;

    setState(() {
      _isSigningOut = true;
    });

    try {
      await _auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (_) {
      _showMessage('Unable to sign out. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  // =====================================================
  // BUILD SCREEN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.lightGreen,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // EMAIL ICON

                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.lightGreen,

                    child: Icon(
                      _isVerified
                          ? Icons.verified_user_outlined
                          : Icons.mark_email_unread_outlined,

                      size: 55,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // HEADING
                Text(
                  _isVerified ? 'Email Verified!' : 'Verify Your Email',

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),

                const SizedBox(height: 16),

                // DESCRIPTION
                Text(
                  _isVerified
                      ? 'Your email address has been verified successfully.'
                      : 'Welcome to Rural Spark! 🌱\n\n'
                            'We have sent a verification link to:',

                  textAlign: TextAlign.center,

                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),

                if (!_isVerified) ...[
                  const SizedBox(height: 12),

                  Text(
                    _email,

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Please open your email and click the '
                    'verification link to activate your account.\n\n'
                    'Remember to check your spam or junk folder.',

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 15, height: 1.6),
                  ),
                ],

                const SizedBox(height: 32),

                // CHECK VERIFICATION BUTTON
                SizedBox(
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : () => _checkVerification(),

                    icon: _isChecking
                        ? const SizedBox(
                            width: 18,
                            height: 18,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified_outlined),

                    label: Text(
                      _isChecking
                          ? 'Checking...'
                          : _isVerified
                          ? 'Continue to Dashboard'
                          : 'I Have Verified My Email',
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // RESEND VERIFICATION EMAIL
                if (!_isVerified)
                  SizedBox(
                    height: 50,

                    child: OutlinedButton.icon(
                      onPressed: _isResending ? null : _resendVerificationEmail,

                      icon: const Icon(Icons.refresh),

                      label: Text(
                        _isResending
                            ? 'Sending...'
                            : 'Resend Verification Email',
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.darkGreen,
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                // BACK TO LOGIN
                TextButton.icon(
                  onPressed: _isSigningOut ? null : _backToLogin,

                  icon: const Icon(Icons.arrow_back),

                  label: Text(
                    _isSigningOut ? 'Signing out...' : 'Back to Login',
                  ),

                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.darkGreen,
                  ),
                ),

                const SizedBox(height: 22),

                // HELP INFORMATION
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Icon(Icons.info_outline, color: AppColors.darkGreen),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Did not receive the email?\n\n'
                          '1. Check your inbox.\n'
                          '2. Check your spam or junk folder.\n'
                          '3. Click Resend Verification Email.\n'
                          '4. Open the verification link.\n'
                          '5. Return here and click '
                          'I Have Verified My Email.',

                          style: TextStyle(fontSize: 13, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
