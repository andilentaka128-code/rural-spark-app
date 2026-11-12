
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  Future<void> _openLink(
    BuildContext context,
    String link,
  ) async {
    final uri = Uri.parse(link);

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong while opening the link.',
            ),
          ),
        );
      }
    }
  }

  Widget _registrationStep(
    int number,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: AppColors.lightGreen,
            child: Text(
              '$number',
              style: const TextStyle(
                color: AppColors.darkGreen,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.business_outlined,
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
                        'Get official registration guidance '
                        'and find nearby assistance.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'How to Register Your Business',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Follow these general steps to register '
                  'a company in South Africa.',
                  style: TextStyle(
                    color: AppColors.grey,
                  ),
                ),

                const SizedBox(height: 22),

                _registrationStep(
                  1,
                  'Prepare your ID and business information',
                  'Have your South African ID or other '
                      'accepted identification and the '
                      'required business details ready.',
                ),

                _registrationStep(
                  2,
                  'Create or access your CIPC account',
                  'Visit the official CIPC registration '
                      'service and create an account '
                      'or sign in.',
                ),

                _registrationStep(
                  3,
                  'Select the company type and enter details',
                  'Choose the appropriate company type '
                      'and complete the required information.',
                ),

                _registrationStep(
                  4,
                  'Review and submit your application',
                  'Check your details, pay any applicable '
                      'registration fee and submit.',
                ),

                _registrationStep(
                  5,
                  'Save your registration confirmation',
                  'Keep your company registration documents '
                      'and confirmation in a safe place.',
                ),

                const SizedBox(height: 16),

                // OFFICIAL REGISTRATION BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openLink(
                      context,
                      'https://www.bizportal.gov.za/',
                    ),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text(
                      'Open CIPC Registration',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // GOOGLE MAPS BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openLink(
                      context,
                      'https://www.google.com/maps/search/'
                      '?api=1&query=business+registration'
                      '+assistance+near+me',
                    ),
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text(
                      'Find Registration Help Near Me',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGreen,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // CIPC SERVICE CENTRES
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openLink(
                      context,
                      'https://www.cipc.co.za/',
                    ),
                    icon: const Icon(Icons.account_balance_outlined),
                    label: const Text(
                      'Visit Official CIPC Website',
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.darkGreen,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Rural Spark provides registration '
                          'guidance. Official registration is '
                          'completed through CIPC. Google Maps '
                          'search results may include independent '
                          'service providers, so verify their '
                          'credentials before sharing documents '
                          'or making payments.',
                          style: TextStyle(height: 1.5),
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
