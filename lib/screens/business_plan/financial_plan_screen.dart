import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import 'business_overview_screen.dart';
import 'business_plan_preview_screen.dart';

class FinancialPlanScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const FinancialPlanScreen({super.key, required this.draft});

  @override
  State<FinancialPlanScreen> createState() => _FinancialPlanScreenState();
}

class _FinancialPlanScreenState extends State<FinancialPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _startupCostController;
  late final TextEditingController _incomeController;
  late final TextEditingController _expensesController;

  @override
  void initState() {
    super.initState();

    _startupCostController = TextEditingController(
      text: widget.draft['startupCost']?.toString() ?? '',
    );

    _incomeController = TextEditingController(
      text: widget.draft['expectedMonthlyIncome']?.toString() ?? '',
    );

    _expensesController = TextEditingController(
      text: widget.draft['expectedMonthlyExpenses']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _startupCostController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    super.dispose();
  }

  double parseAmount(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  double get expectedProfit {
    return parseAmount(_incomeController.text) -
        parseAmount(_expensesController.text);
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount.';
    }

    final amount = double.tryParse(value.replaceAll(',', '').trim());

    if (amount == null) {
      return 'Please enter numbers only.';
    }

    if (amount < 0) {
      return 'Amount cannot be negative.';
    }

    return null;
  }

  void previewPlan() {
    if (!_formKey.currentState!.validate()) return;

    widget.draft['startupCost'] = parseAmount(_startupCostController.text);

    widget.draft['expectedMonthlyIncome'] = parseAmount(_incomeController.text);

    widget.draft['expectedMonthlyExpenses'] = parseAmount(
      _expensesController.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BusinessPlanPreviewScreen(draft: widget.draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Plan')),
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
                  const StepProgress(step: 4, title: 'Financial Plan'),
                  const SizedBox(height: 25),
                  const Text(
                    'Plan your business finances',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter simple estimates. You can update these figures as your business develops.',
                    style: TextStyle(color: AppColors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _startupCostController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Estimated startup cost',
                      hintText: 'Example: 5000',
                      prefixText: 'R ',
                      prefixIcon: Icon(Icons.savings_outlined),
                    ),
                    validator: validateAmount,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _incomeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Expected monthly income',
                      hintText: 'Example: 12000',
                      prefixText: 'R ',
                      prefixIcon: Icon(Icons.trending_up_outlined),
                    ),
                    validator: validateAmount,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _expensesController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Expected monthly expenses',
                      hintText: 'Example: 7000',
                      prefixText: 'R ',
                      prefixIcon: Icon(Icons.trending_down_outlined),
                    ),
                    validator: validateAmount,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 25),
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
                        const Text(
                          'Estimated Monthly Profit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'R ${expectedProfit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: expectedProfit >= 0
                                ? AppColors.darkGreen
                                : AppColors.danger,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Monthly income minus monthly expenses.',
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: previewPlan,
                          icon: const Icon(Icons.visibility_outlined),
                          label: const Text(
                            'Preview My Plan',
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
