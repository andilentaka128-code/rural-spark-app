import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'business_overview_screen.dart';
import 'financial_plan_screen.dart';

class MarketingPlanScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const MarketingPlanScreen({super.key, required this.draft});

  @override
  State<MarketingPlanScreen> createState() => _MarketingPlanScreenState();
}

class _MarketingPlanScreenState extends State<MarketingPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _marketingController;
  late final TextEditingController _salesController;

  @override
  void initState() {
    super.initState();

    _marketingController = TextEditingController(
      text: widget.draft['marketingStrategy'] ?? '',
    );

    _salesController = TextEditingController(
      text: widget.draft['salesStrategy'] ?? '',
    );
  }

  @override
  void dispose() {
    _marketingController.dispose();
    _salesController.dispose();
    super.dispose();
  }

  void continueToNextStep() {
    if (!_formKey.currentState!.validate()) return;

    widget.draft['marketingStrategy'] = _marketingController.text.trim();

    widget.draft['salesStrategy'] = _salesController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FinancialPlanScreen(draft: widget.draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketing & Sales')),
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
                  const StepProgress(step: 3, title: 'Marketing & Sales'),

                  const SizedBox(height: 25),

                  const Text(
                    'How will customers find you?',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Explain how you will promote your business and how customers will buy from you.',
                    style: TextStyle(color: AppColors.grey, height: 1.5),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: _marketingController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Marketing strategy',
                      hintText: 'Example: WhatsApp, Facebook, posters, referrals or community events.',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.campaign_outlined),
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: _salesController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Sales strategy',
                      hintText: 'Explain where customers will buy and how you will receive orders.',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: continueToNextStep,
                          child: const Text(
                            'Continue to Finances',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
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
