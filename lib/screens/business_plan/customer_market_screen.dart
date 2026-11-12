import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'business_overview_screen.dart';
import 'marketing_plan_screen.dart';

class CustomerMarketScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const CustomerMarketScreen({super.key, required this.draft});

  @override
  State<CustomerMarketScreen> createState() => _CustomerMarketScreenState();
}

class _CustomerMarketScreenState extends State<CustomerMarketScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _customersController;
  late final TextEditingController _needsController;
  late final TextEditingController _competitorsController;
  late final TextEditingController _advantageController;

  @override
  void initState() {
    super.initState();

    _customersController = TextEditingController(
      text: widget.draft['targetCustomers'] ?? '',
    );

    _needsController = TextEditingController(
      text: widget.draft['customerNeeds'] ?? '',
    );

    _competitorsController = TextEditingController(
      text: widget.draft['competitors'] ?? '',
    );

    _advantageController = TextEditingController(
      text: widget.draft['competitiveAdvantage'] ?? '',
    );
  }

  @override
  void dispose() {
    _customersController.dispose();
    _needsController.dispose();
    _competitorsController.dispose();
    _advantageController.dispose();
    super.dispose();
  }

  void continueToNextStep() {
    if (!_formKey.currentState!.validate()) return;

    widget.draft['targetCustomers'] = _customersController.text.trim();

    widget.draft['customerNeeds'] = _needsController.text.trim();

    widget.draft['competitors'] = _competitorsController.text.trim();

    widget.draft['competitiveAdvantage'] = _advantageController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarketingPlanScreen(draft: widget.draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers & Market')),
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
                  const StepProgress(step: 2, title: 'Customers & Market'),

                  const SizedBox(height: 25),

                  const Text(
                    'Who will buy from you?',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Think about the people who need your product or service and other businesses serving them.',
                    style: TextStyle(color: AppColors.grey, height: 1.5),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: _customersController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Who are your target customers?',
                      hintText: 'Example: Local households, students, farmers or small businesses.',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.groups_outlined),
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _needsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'What do your customers need?',
                      hintText: 'Explain what your customers are looking for or struggling with.',
                      alignLabelWithHint: true,
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _competitorsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Who are your competitors?',
                      hintText: 'Mention businesses offering similar products or services.',
                      alignLabelWithHint: true,
                    ),
                    validator: requiredField,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _advantageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'What will make your business different?',
                      hintText: 'Example: Better prices, local delivery, convenience or better service.',
                      alignLabelWithHint: true,
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
                            'Continue',
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
