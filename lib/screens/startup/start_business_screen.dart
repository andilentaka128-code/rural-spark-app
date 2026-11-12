import 'explore_business_ideas_screen.dart';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'viability_questions_screen.dart';

class StartBusinessScreen extends StatelessWidget {
  const StartBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'exploreBusinessIdeas',
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Explore Business Ideas'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ExploreBusinessIdeasScreen(),
            ),
          );
        },
      ),
      appBar: AppBar(title: const Text('Start My Business')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 45,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Is your business idea ready?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Before investing your time and money, Rural Spark can help you think through your idea.',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Idea Viability Check',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Answer a few simple questions about your customers, demand, competition, skills and startup finances.',
                  style: TextStyle(height: 1.5, color: AppColors.grey),
                ),

                const SizedBox(height: 25),

                const AssessmentPoint(
                  icon: Icons.people_outline,
                  title: 'Customers',
                  description: 'Do you know who is likely to buy your product or service?',
                ),

                const AssessmentPoint(
                  icon: Icons.trending_up,
                  title: 'Demand',
                  description: 'Is there a real need for your business idea?',
                ),

                const AssessmentPoint(
                  icon: Icons.storefront_outlined,
                  title: 'Competition',
                  description: 'Do you understand businesses already serving the same market?',
                ),

                const AssessmentPoint(
                  icon: Icons.psychology_outlined,
                  title: 'Skills',
                  description:
                      'Do you have the skills needed to start the business?',
                ),

                const AssessmentPoint(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Startup Finance',
                  description: 'Have you considered how much money you need to get started?',
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: AppColors.darkGreen),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This assessment is a planning guide, not a guarantee that a business will succeed.',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'Start Idea Assessment',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViabilityQuestionsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssessmentPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AssessmentPoint({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreen,
          child: Icon(icon, color: AppColors.darkGreen),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
      ),
    );
  }
}
