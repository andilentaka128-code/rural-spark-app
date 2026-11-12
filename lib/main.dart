import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/home/home_screen.dart';

// =====================================================
// MAIN APPLICATION
// =====================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaEnterpriseProvider(
      const String.fromEnvironment('RECAPTCHA_SITE_KEY'),
    ),
  );

  runApp(const RuralSparkApp());
}

// =====================================================
// RURAL SPARK APP
// =====================================================

class RuralSparkApp extends StatelessWidget {
  const RuralSparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rural Spark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}

// =====================================================
// AUTHENTICATION GATE
// =====================================================

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> _checkEmailVerification(User user) async {
    try {
      // Fetch the latest verification status from Firebase.
      await user.reload();

      final updatedUser = _auth.currentUser;

      return updatedUser?.emailVerified == true;
    } catch (_) {
      // Do not allow access when verification cannot be confirmed.
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),

      builder: (context, snapshot) {
        // WAIT FOR FIREBASE AUTHENTICATION
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // USER IS NOT LOGGED IN
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final User user = snapshot.data!;

        // CHECK EMAIL VERIFICATION
        return FutureBuilder<bool>(
          future: _checkEmailVerification(user),

          builder: (context, verificationSnapshot) {
            // WAIT FOR VERIFICATION CHECK
            if (verificationSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // VERIFIED USER
            if (verificationSnapshot.data == true) {
              return const HomeScreen();
            }

            // UNVERIFIED USER
            return const VerifyEmailScreen();
          },
        );
      },
    );
  }
}
