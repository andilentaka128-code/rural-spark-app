import '../business_plan/business_plan_preview_screen.dart';
import '../../services/firestore_service.dart';
import '../documents/my_business_documents_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class StartupJourneyScreen extends StatelessWidget {
  const StartupJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view your startup journey.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Startup Journey')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() ?? {};

          final bool profileCompleted = data['profileCompleted'] == true;

          final bool viabilityCompleted = data['viabilityCompleted'] == true;

          final bool businessPlanCompleted =
              data['businessPlanCompleted'] == true;

          final bool registrationCompleted =
              data['registrationCompleted'] == true;

          final bool fundingCompleted = data['fundingCompleted'] == true;

          final bool goalsCompleted = data['goalsCompleted'] == true;

          final steps = [
            JourneyStep(
              title: 'Complete your profile',
              subtitle: 'Tell Rural Spark about you and your idea',
              completed: profileCompleted,
            ),
            JourneyStep(
              title: 'Evaluate your business idea',
              subtitle: 'Check whether your idea is ready',
              completed: viabilityCompleted,
            ),
            JourneyStep(
              title: 'Complete your business plan',
              subtitle: 'Turn your idea into a structured plan',
              completed: businessPlanCompleted,
            ),
            JourneyStep(
              title: 'Check business registration',
              subtitle: 'Learn how to formalise your business',
              completed: registrationCompleted,
            ),
            JourneyStep(
              title: 'Find suitable funding',
              subtitle: 'Explore funding opportunities',
              completed: fundingCompleted,
            ),
            JourneyStep(
              title: 'Set your first business goal',
              subtitle: 'Create goals and track progress',
              completed: goalsCompleted,
            ),
          ];

          final completed = steps.where((step) => step.completed).length;

          final progress = steps.isEmpty ? 0.0 : completed / steps.length;

          final percentage = (progress * 100).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Startup Journey',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Follow these steps to turn your idea into a stronger and more prepared business.',
                      style: TextStyle(color: AppColors.grey, height: 1.5),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Journey Progress',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 9,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '$completed of ${steps.length} steps completed',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ...List.generate(steps.length, (index) {
                      final step = steps[index];

                      return JourneyStepCard(number: index + 1, step: step);
                    }),

                    const SizedBox(height: 30),

                    const Text(
                      'My Saved Documents',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Access and update your business documents for funding and registration preparation.',
                      style: TextStyle(color: AppColors.grey, height: 1.5),
                    ),

                    const SizedBox(height: 20),

                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_outlined,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Business Idea Summary',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Edit your business idea and generate a PDF using your saved information.',
                              style: TextStyle(color: AppColors.grey),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MyBusinessDocumentsScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit_document),
                                label: const Text('Edit / View / Download PDF'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (businessPlanCompleted) ...[
                      const SizedBox(height: 14),
                      const SavedBusinessPlanCard(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SavedBusinessPlanCard extends StatelessWidget {
  const SavedBusinessPlanCard({super.key});

  Future<void> _openSavedPlan(BuildContext context) async {
    try {
      final savedPlan = await FirestoreService().getBusinessPlan();

      if (!context.mounted) return;

      if (savedPlan == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No saved business plan found.')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BusinessPlanPreviewScreen(draft: savedPlan),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load business plan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description_outlined, color: AppColors.primaryGreen),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'My Business Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Your completed business plan has been saved successfully.',
              style: TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openSavedPlan(context),
                icon: const Icon(Icons.edit_document),
                label: const Text('Edit / View / Download PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyStep {
  final String title;
  final String subtitle;
  final bool completed;

  JourneyStep({
    required this.title,
    required this.subtitle,
    required this.completed,
  });
}

class JourneyStepCard extends StatelessWidget {
  final int number;
  final JourneyStep step;

  const JourneyStepCard({super.key, required this.number, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: step.completed
              ? AppColors.primaryGreen
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: step.completed
                ? AppColors.primaryGreen
                : AppColors.lightGreen,
            child: step.completed
                ? const Icon(Icons.check, color: Colors.white)
                : Text(
                    '$number',
                    style: const TextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.completed
                        ? AppColors.darkGreen
                        : AppColors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  step.completed ? 'Completed' : step.subtitle,
                  style: TextStyle(
                    color: step.completed ? AppColors.success : AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            step.completed ? Icons.check_circle : Icons.chevron_right,
            color: step.completed ? AppColors.success : AppColors.grey,
          ),
        ],
      ),
    );
  }
}
