import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'funding_readiness_screen.dart';

class FundingScreen extends StatelessWidget {
  const FundingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Funding',
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
                        Icons.account_balance_outlined,
                        size: 42,
                        color: Colors.white,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Find Funding for Your Business',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Check whether your business is ready for funding and discover opportunities that may suit your needs.',
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Before you apply',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Funding providers may require information about your business, finances and plans.',
                  style: TextStyle(color: AppColors.grey, height: 1.5),
                ),

                const SizedBox(height: 18),

                const FundingInfoCard(
                  icon: Icons.description_outlined,
                  title: 'Business Plan',
                  description: 'A clear explanation of your business, customers and finances.',
                ),

                const FundingInfoCard(
                  icon: Icons.person_outline,
                  title: 'Owner Information',
                  description: 'Basic information about you and the people involved in the business.',
                ),

                const FundingInfoCard(
                  icon: Icons.payments_outlined,
                  title: 'Financial Information',
                  description: 'Your estimated startup costs, income, expenses and funding needs.',
                ),

                const FundingInfoCard(
                  icon: Icons.verified_outlined,
                  title: 'Business Documents',
                  description: 'Some funding opportunities may require registration or supporting documents.',
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FundingReadinessScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text(
                    'Check My Funding Readiness',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),

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
                        Icons.warning_amber_outlined,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Never pay someone who promises guaranteed business funding. Always verify opportunities before sharing personal information.',
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

class FundingInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FundingInfoCard({
    super.key,
    required this.icon,
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
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.darkGreen),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.grey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
