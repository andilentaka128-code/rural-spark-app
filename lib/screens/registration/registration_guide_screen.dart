import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'registration_checklist_screen.dart';

class RegistrationGuideScreen extends StatelessWidget {
  const RegistrationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        color: Colors.white,
                        size: 42,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Register Your Business',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Use this guide to understand the main steps you may need when formalising your business.',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Registration Journey',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                const RegistrationStep(
                  number: '1',
                  title: 'Choose your business name',
                  description:
                      'Decide on a suitable name for your business.',
                ),

                const RegistrationStep(
                  number: '2',
                  title: 'Choose a business structure',
                  description:
                      'Understand which type of business structure is suitable for your situation.',
                ),

                const RegistrationStep(
                  number: '3',
                  title: 'Prepare your information',
                  description:
                      'Prepare the personal and business information required during registration.',
                ),

                const RegistrationStep(
                  number: '4',
                  title: 'Complete official registration',
                  description:
                      'Use the appropriate official government registration service for your business.',
                ),

                const RegistrationStep(
                  number: '5',
                  title: 'Keep your business records',
                  description:
                      'Store your registration documents and important business records safely.',
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const RegistrationChecklistScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.checklist_outlined),
                  label: const Text(
                    'Open My Registration Checklist',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rural Spark provides guidance only. Always confirm current registration requirements through the relevant official government service.',
                          style: TextStyle(height: 1.4),
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

class RegistrationStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const RegistrationStep({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.darkGreen,
            foregroundColor: Colors.white,
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
