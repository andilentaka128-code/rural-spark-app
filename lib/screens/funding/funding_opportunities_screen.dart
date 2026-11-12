import 'funding_easy_apply_screen.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class FundingOpportunitiesScreen extends StatelessWidget {
  final int readinessScore;
  final String location;
  final bool isRegistered;
  final bool hasBusinessPlan;
  final bool knowsFundingAmount;
  final bool knowsFundingPurpose;
  final bool hasFinancialEstimate;
  final bool hasSupportingDocuments;

  const FundingOpportunitiesScreen({
    super.key,
    required this.readinessScore,
    required this.location,
    required this.isRegistered,
    required this.hasBusinessPlan,
    required this.knowsFundingAmount,
    required this.knowsFundingPurpose,
    required this.hasFinancialEstimate,
    required this.hasSupportingDocuments,
  });

  Future<void> openWebsite(BuildContext context, String website) async {
    final uri = Uri.parse(website);

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open website.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open website.')),
        );
      }
    }
  }

  Widget fundingCard({
    required BuildContext context,
    required String title,
    required String type,
    required String description,
    required String matchReason,
    required List<String> steps,
    required String website,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 18),
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
            const SizedBox(height: 10),
            Text(
              type,
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(matchReason, style: const TextStyle(height: 1.4)),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FundingEasyApplyScreen(programme: title),
                  ),
                ),
                icon: const Icon(Icons.edit_document),
                label: const Text('Easy Apply in Rural Spark'),
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'Steps to follow',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...steps.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => openWebsite(context, website),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Visit Official Website'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missingItems = <String>[
      if (!hasBusinessPlan) 'Complete your business plan.',
      if (!knowsFundingAmount) 'Calculate how much funding you need.',
      if (!knowsFundingPurpose) 'Explain what you will use the funding for.',
      if (!hasFinancialEstimate) 'Prepare your income and expense estimates.',
      if (!hasSupportingDocuments) 'Gather your supporting documents.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Funding Opportunities')),
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
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Funding Guidance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Readiness: $readinessScore%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore funding options and check each programme for eligibility.',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (missingItems.isNotEmpty) ...[
                  const Text(
                    'What You Should Prepare Next',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...missingItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.checklist,
                            color: AppColors.darkGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                const Text(
                  'Explore Public Funding & Support',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'These are possible options to investigate. '
                  'Your answers do not confirm eligibility, '
                  'availability or approval.',
                ),
                const SizedBox(height: 18),

                if (true)
                  fundingCard(
                    context: context,
                    title: 'NYDA Youth Grant',
                    type: 'Youth entrepreneurship grant',
                    description:
                        'The National Youth Development Agency '
                        'supports eligible young South African entrepreneurs.',
                    matchReason:
                        'This programme supports eligible youth entrepreneurs. '
                        'Citizenship, ownership, training and other '
                        'requirements still need to be checked.',
                    icon: Icons.emoji_events_outlined,
                    website: 'https://www.nyda.gov.za/',
                    steps: const [
                      'Visit the NYDA website and find its grant programme.',
                      'Check the current eligibility requirements.',
                      'Prepare your ID and business information.',
                      'Complete any required business training or assessment.',
                      'Follow the official application instructions.',
                    ],
                  ),

                fundingCard(
                  context: context,
                  title: 'Seda / SEDFA Business Support',
                  type: 'Business development assistance',
                  description:
                      'Get help with business planning, training, '
                      'registration and preparing for finance applications.',
                  matchReason: readinessScore < 80
                      ? 'Recommended preparation support: some '
                            'funding-readiness items are still missing.'
                      : 'Useful for reviewing your business plan '
                            'and identifying appropriate support services.',
                  icon: Icons.school_outlined,
                  website: 'https://www.seda.org.za/',
                  steps: const [
                    'Visit the official Seda website.',
                    'Find the nearest business support office.',
                    'Explain your business idea and funding needs.',
                    'Ask for business planning and finance-readiness support.',
                    'Follow the adviserÃ¢â‚¬â„¢s guidance on available programmes.',
                  ],
                ),

                fundingCard(
                  context: context,
                  title: 'SEDFA / sefa Business Finance',
                  type: 'Small-business finance, including loans',
                  description:
                      'Explore business finance products. '
                      'Loans generally require evidence of '
                      'viability and ability to repay.',
                  matchReason:
                      'Possible finance option to investigate. '
                      '${isRegistered ? "You reported a registered business." : "Check whether registration is required for the chosen product."} '
                      'Financial viability has not been verified.',
                  icon: Icons.account_balance_outlined,
                  website: 'https://www.sefa.org.za/',
                  steps: const [
                    'Review the available finance products and criteria.',
                    'Prepare a business plan and financial forecasts.',
                    'Calculate the amount needed and repayment affordability.',
                    'Gather business and owner documents.',
                    'Submit an enquiry or application through the official channel.',
                  ],
                ),

                fundingCard(
                  context: context,
                  title: 'National Empowerment Fund',
                  type: 'Development finance',
                  description:
                      'The NEF provides business finance under '
                      'specific empowerment and investment criteria.',
                  matchReason:
                      'An additional public finance option to review. '
                      'The assessment does not establish NEF eligibility.',
                  icon: Icons.business_center_outlined,
                  website: 'https://www.nefcorp.co.za/',
                  steps: const [
                    'Visit the NEF website and review its funding products.',
                    'Check the ownership and programme requirements.',
                    'Prepare a business plan and financial projections.',
                    'Gather the required company and owner documents.',
                    'Follow the official application instructions.',
                  ],
                ),

                const SizedBox(height: 8),
                const Text(
                  'Important: Government programmes, application '
                  'requirements and available funding can change. '
                  'Always verify details on the official website.',
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
