import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class BusinessSupportScreen extends StatelessWidget {
  const BusinessSupportScreen({super.key});

  Future<void> _openMap(BuildContext context, String search) async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$search near me',
    });

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open Google Maps.')),
        );
      }
    }
  }

  Widget _supportCard({
    required BuildContext context,
    required String title,
    required String description,
    required String search,
    required IconData icon,
    required List<String> documents,
    required String note,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightGreen,
                  child: Icon(icon, color: AppColors.darkGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(description, style: const TextStyle(height: 1.5)),

            const SizedBox(height: 18),

            const Text(
              'What to bring or prepare',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            ...documents.map(
              (document) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.darkGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 9),
                    Expanded(child: Text(document)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(note, style: const TextStyle(height: 1.5)),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openMap(context, search),
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions on Google Maps'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openMap(context, search),
                icon: const Icon(Icons.map_outlined),
                label: Text('Find $title Near Me'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Support Near Me')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 42,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Find Business Support Near You',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Find nearby funding assistance, '
                        'registration help, training and '
                        'business advice. Prepare before '
                        'visiting a support centre.',
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                _supportCard(
                  context: context,
                  title: 'Funding Support',
                  icon: Icons.account_balance_outlined,
                  search: 'small business funding support SEDA NYDA SEDFA',
                  description:
                      'Find organisations that can advise '
                      'you about grants, loans and business '
                      'finance applications.',
                  documents: const [
                    'South African ID or accepted identification.',
                    'A short description of your business idea.',
                    'Business plan, if available.',
                    'Estimated amount of funding needed.',
                    'List of what the funding will pay for.',
                    'Income and expense estimates, if available.',
                    'Business registration documents, if registered.',
                  ],
                  note:
                      'Funding is not guaranteed. Ask the '
                      'organisation which programmes are '
                      'currently accepting applications '
                      'and what documents are required.',
                ),

                _supportCard(
                  context: context,
                  title: 'Registration Help',
                  icon: Icons.business_outlined,
                  search: 'CIPC business registration assistance',
                  description:
                      'Find places that may assist you '
                      'with company registration and '
                      'understanding CIPC requirements.',
                  documents: const [
                    'South African ID or accepted identification.',
                    'Your proposed business name or name ideas.',
                    'Contact number and email address.',
                    'Business address and basic company details.',
                    'Information about directors or owners.',
                    'Money for any applicable official fees.',
                  ],
                  note:
                      'Check that the provider is authorised '
                      'or reputable. You can also register '
                      'through the official CIPC BizPortal.',
                ),

                _supportCard(
                  context: context,
                  title: 'Business Training',
                  icon: Icons.school_outlined,
                  search: 'SEDA entrepreneurship training business skills',
                  description:
                      'Find entrepreneurship workshops '
                      'and training in business planning, '
                      'financial management and marketing.',
                  documents: const [
                    'ID or accepted identification.',
                    'Contact number and email address.',
                    'Notebook or device for taking notes.',
                    'A description of your business idea.',
                    'Business registration details, if available.',
                    'Any confirmation of a training booking.',
                  ],
                  note:
                      'Ask whether the training is free, '
                      'whether booking is required and '
                      'whether a certificate is provided.',
                ),

                _supportCard(
                  context: context,
                  title: 'Business Advice',
                  icon: Icons.support_agent_outlined,
                  search: 'SEDA small business development advice',
                  description:
                      'Find business advisers who may '
                      'help you with business plans, '
                      'pricing, marketing and business growth.',
                  documents: const [
                    'ID or accepted identification.',
                    'A description of your business idea.',
                    'Your main business questions or challenges.',
                    'Draft business plan, if available.',
                    'Information about customers and competitors.',
                    'Basic sales and expense information, if operating.',
                  ],
                  note:
                      'Explain what help you need and ask '
                      'whether an appointment is required.',
                ),

                const SizedBox(height: 8),

                const Text(
                  'Google Maps displays search results, '
                  'not a verified list of government offices. '
                  'Check the organisation, opening hours, '
                  'fees and required documents before travelling.',
                  style: TextStyle(color: AppColors.grey, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
