import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/firestore_service.dart';
import 'add_goal_screen.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Goals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddGoalScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Goal'),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: service.goalsStream(),
        builder: (context, snapshot) {
          // -------------------------------------------------
          // LOADING
          // -------------------------------------------------

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // -------------------------------------------------
          // FIREBASE ERROR
          // -------------------------------------------------

          if (snapshot.hasError) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 65,
                        color: AppColors.danger,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Could not load your goals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Firebase returned the following error:',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey),
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: SelectableText(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.danger,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final goals = snapshot.data?.docs ?? [];

          // -------------------------------------------------
          // NO GOALS
          // -------------------------------------------------

          if (goals.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flag_outlined,
                          size: 50,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'No goals yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Create your first business goal and start tracking your progress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey, height: 1.5),
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddGoalScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Create My First Goal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // -------------------------------------------------
          // GOALS LIST
          // -------------------------------------------------

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final document = goals[index];
              final data = document.data();

              final title = data['title']?.toString() ?? 'Business Goal';

              final description = data['description']?.toString() ?? '';

              final completed = data['completed'] == true;

              DateTime? dueDate;

              final dueDateData = data['dueDate'];

              if (dueDateData is Timestamp) {
                dueDate = dueDateData.toDate();
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: completed
                        ? AppColors.success
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: completed,
                      activeColor: AppColors.darkGreen,
                      onChanged: (value) async {
                        try {
                          await service.updateGoalStatus(
                            goalId: document.id,
                            completed: value ?? false,
                          );
                        } catch (error) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Could not update goal: $error'),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),

                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(
                                color: AppColors.grey,
                                height: 1.4,
                              ),
                            ),
                          ],

                          if (dueDate != null) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 17,
                                  color: AppColors.darkGreen,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  'Target: '
                                  '${dueDate.day}/'
                                  '${dueDate.month}/'
                                  '${dueDate.year}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          if (completed) ...[
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 17,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    IconButton(
                      tooltip: 'Delete goal',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.danger,
                      ),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Delete Goal?'),
                              content: Text(
                                'Are you sure you want to delete "$title"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, true);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.danger),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete != true) {
                          return;
                        }

                        try {
                          await service.deleteGoal(document.id);
                        } catch (error) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Could not delete goal: $error'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
