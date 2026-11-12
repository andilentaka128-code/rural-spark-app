import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'customer_market_screen.dart';

class BusinessOverviewScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const BusinessOverviewScreen({super.key, required this.draft});

  @override
  State<BusinessOverviewScreen> createState() => _BusinessOverviewScreenState();
}

class _BusinessOverviewScreenState extends State<BusinessOverviewScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _businessNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _problemController;
  late final TextEditingController _productsController;

  @override
  void initState() {
    super.initState();

    _businessNameController = TextEditingController(
      text: widget.draft['businessName'] ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.draft['businessDescription'] ?? '',
    );

    _problemController = TextEditingController(
      text: widget.draft['problemSolved'] ?? '',
    );

    _productsController = TextEditingController(
      text: widget.draft['productsServices'] ?? '',
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _problemController.dispose();
    _productsController.dispose();
    super.dispose();
  }

  void continueToNextStep() {
    if (!_formKey.currentState!.validate()) return;

    widget.draft['businessName'] = _businessNameController.text.trim();

    widget.draft['businessDescription'] = _descriptionController.text.trim();

    widget.draft['problemSolved'] = _problemController.text.trim();

    widget.draft['productsServices'] = _productsController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerMarketScreen(draft: widget.draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Overview')),
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
                  const StepProgress(step: 1, title: 'Business Overview'),

                  const SizedBox(height: 25),

                  const Text(
                    'Tell us about your business',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Use simple words. You can improve your answers later.',
                    style: TextStyle(color: AppColors.grey),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: _businessNameController,
                    decoration: const InputDecoration(
                      labelText: 'Business name',
                      hintText: 'Example: Nomusa Fresh Produce',
                      prefixIcon: Icon(Icons.storefront_outlined),
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Describe your business',
                      hintText: 'What type of business do you want to start?',
                      alignLabelWithHint: true,
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _problemController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'What problem does your business solve?',
                      hintText: 'Explain the problem customers currently face.',
                      alignLabelWithHint: true,
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _productsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Products or services you will offer',
                      hintText: 'Describe what customers will buy from you.',
                      alignLabelWithHint: true,
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: continueToNextStep,
                    child: const Text(
                      'Continue to Customers & Market',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

String? requiredField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please complete this field.';
  }

  return null;
}

class StepProgress extends StatelessWidget {
  final int step;
  final String title;

  const StepProgress({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $step of 4',
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: step / 4,
          minHeight: 8,
          borderRadius: BorderRadius.circular(20),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: AppColors.grey)),
      ],
    );
  }
}
