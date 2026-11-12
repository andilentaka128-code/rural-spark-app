import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';

class RegistrationChecklistScreen extends StatefulWidget {
  const RegistrationChecklistScreen({super.key});

  @override
  State<RegistrationChecklistScreen> createState() =>
      _RegistrationChecklistScreenState();
}

class _RegistrationChecklistScreenState
    extends State<RegistrationChecklistScreen> {
  bool businessName = false;
  bool businessStructure = false;
  bool personalInformation = false;
  bool registrationInformation = false;
  bool documentsStored = false;

  bool saving = false;

  int get completedCount {
    return [
      businessName,
      businessStructure,
      personalInformation,
      registrationInformation,
      documentsStored,
    ].where((item) => item).length;
  }

  double get progress => completedCount / 5;

  Future<void> completeChecklist() async {
    if (completedCount < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Complete all checklist items before finishing this step.',
          ),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await FirestoreService().completeRegistrationChecklist();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration checklist completed!',
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save your progress: $error',
          ),
        ),
      );
    }
  }

  Widget checklistItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: value
              ? AppColors.darkGreen
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.darkGreen,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Checklist'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track Your Registration',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Tick each item as you prepare for formal business registration.',
                  style: TextStyle(
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Registration Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                          Text(
                            '$completedCount / 5',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                checklistItem(
                  title: 'Business name selected',
                  description:
                      'I have decided on a suitable name for my business.',
                  value: businessName,
                  onChanged: (value) {
                    setState(() {
                      businessName = value ?? false;
                    });
                  },
                ),

                checklistItem(
                  title: 'Business structure considered',
                  description:
                      'I have considered the type of business structure that may suit my business.',
                  value: businessStructure,
                  onChanged: (value) {
                    setState(() {
                      businessStructure = value ?? false;
                    });
                  },
                ),

                checklistItem(
                  title: 'Personal information prepared',
                  description:
                      'I have the personal information and identification details I may need.',
                  value: personalInformation,
                  onChanged: (value) {
                    setState(() {
                      personalInformation = value ?? false;
                    });
                  },
                ),

                checklistItem(
                  title: 'Registration requirements checked',
                  description:
                      'I have checked the current requirements using the relevant official service.',
                  value: registrationInformation,
                  onChanged: (value) {
                    setState(() {
                      registrationInformation = value ?? false;
                    });
                  },
                ),

                checklistItem(
                  title: 'Business records prepared',
                  description:
                      'I have a safe place to keep important registration and business documents.',
                  value: documentsStored,
                  onChanged: (value) {
                    setState(() {
                      documentsStored = value ?? false;
                    });
                  },
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: saving ? null : completeChecklist,
                  icon: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    saving
                        ? 'Saving...'
                        : 'Complete Registration Step',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Completing this checklist means you have worked through the Rural Spark registration guidance. It does not itself register your business.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    height: 1.4,
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
