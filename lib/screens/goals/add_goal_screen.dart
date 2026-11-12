import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/firestore_service.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? dueDate;
  bool saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 7),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 3650),
      ),
    );

    if (selected != null) {
      setState(() {
        dueDate = selected;
      });
    }
  }

  Future<void> saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    if (dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a target date.'),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await FirestoreService().addGoal(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: dueDate!,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal added successfully!'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save goal: $error'),
        ),
      );
    }
  }

  String formattedDate() {
    if (dueDate == null) {
      return 'Choose target date';
    }

    return '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.flag_outlined,
                    size: 45,
                    color: AppColors.darkGreen,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Set a Business Goal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Create a clear goal that will help move your business forward.',
                    style: TextStyle(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Goal',
                      hintText: 'Example: Get my first 10 customers',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your goal.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText:
                          'What will you do to achieve this goal?',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please describe your goal.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    onTap: selectDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.darkGreen,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            formattedDate(),
                            style: TextStyle(
                              color: dueDate == null
                                  ? AppColors.grey
                                  : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton.icon(
                    onPressed: saving ? null : saveGoal,
                    icon: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_task),
                    label: Text(
                      saving ? 'Saving...' : 'Save Goal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
