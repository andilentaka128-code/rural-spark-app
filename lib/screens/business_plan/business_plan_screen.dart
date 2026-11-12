import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'business_overview_screen.dart';

class BusinessPlanScreen extends StatelessWidget {
  const BusinessPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Plan',
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
                        Icons.description_outlined,
                        color: Colors.white,
                        size: 42,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Build Your Business Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Turn your business idea into a simple plan that can guide your startup.',
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
                  'Your Business Plan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Rural Spark will guide you through four simple sections.',
                  style: TextStyle(color: AppColors.grey),
                ),

                const SizedBox(height: 20),

                const PlanSectionCard(
                  number: '1',
                  icon: Icons.storefront_outlined,
                  title: 'Business Overview',
                  description: 'Describe your business, what it will offer and the problem it solves.',
                ),

                const PlanSectionCard(
                  number: '2',
                  icon: Icons.groups_outlined,
                  title: 'Customers & Market',
                  description: 'Identify your customers, their needs and your competitors.',
                ),

                const PlanSectionCard(
                  number: '3',
                  icon: Icons.campaign_outlined,
                  title: 'Marketing & Sales',
                  description: 'Explain how customers will discover and buy from your business.',
                ),

                const PlanSectionCard(
                  number: '4',
                  icon: Icons.payments_outlined,
                  title: 'Financial Plan',
                  description: 'Estimate your startup costs, income and monthly expenses.',
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BusinessOverviewScreen(draft: <String, dynamic>{}),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Start My Business Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    'You can review your complete plan before saving it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey, fontSize: 13),
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

class PlanSectionCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const PlanSectionCard({
    super.key,
    required this.number,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.darkGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. $title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
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
