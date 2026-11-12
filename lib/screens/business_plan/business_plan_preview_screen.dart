import 'package:flutter/material.dart';

import '../../services/business_plan_pdf_service.dart';
import '../../core/app_colors.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';

class BusinessPlanPreviewScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const BusinessPlanPreviewScreen({super.key, required this.draft});

  @override
  State<BusinessPlanPreviewScreen> createState() =>
      _BusinessPlanPreviewScreenState();
}

class _BusinessPlanPreviewScreenState extends State<BusinessPlanPreviewScreen> {
  bool saving = false;

  double amount(String key) {
    final value = widget.draft[key];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String text(String key) {
    return widget.draft[key]?.toString() ?? '';
  }

  Future<void> savePlan() async {
    setState(() {
      saving = true;
    });

    try {
      await FirestoreService().saveBusinessPlan(
        businessName: text('businessName'),
        businessDescription: text('businessDescription'),
        problemSolved: text('problemSolved'),
        productsServices: text('productsServices'),
        targetCustomers: text('targetCustomers'),
        customerNeeds: text('customerNeeds'),
        competitors: text('competitors'),
        competitiveAdvantage: text('competitiveAdvantage'),
        marketingStrategy: text('marketingStrategy'),
        salesStrategy: text('salesStrategy'),
        startupCost: amount('startupCost'),
        expectedMonthlyIncome: amount('expectedMonthlyIncome'),
        expectedMonthlyExpenses: amount('expectedMonthlyExpenses'),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business plan saved successfully!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save business plan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthlyProfit =
        amount('expectedMonthlyIncome') - amount('expectedMonthlyExpenses');

    return Scaffold(
      appBar: AppBar(title: const Text('Business Plan Preview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Business Plan',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        text('businessName'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Review your information before saving.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                PlanPreviewSection(
                  icon: Icons.storefront_outlined,
                  title: 'Business Overview',
                  items: [
                    PreviewItem(
                      label: 'Business Description',
                      value: text('businessDescription'),
                    ),
                    PreviewItem(
                      label: 'Problem Being Solved',
                      value: text('problemSolved'),
                    ),
                    PreviewItem(
                      label: 'Products / Services',
                      value: text('productsServices'),
                    ),
                  ],
                ),

                PlanPreviewSection(
                  icon: Icons.groups_outlined,
                  title: 'Customers & Market',
                  items: [
                    PreviewItem(
                      label: 'Target Customers',
                      value: text('targetCustomers'),
                    ),
                    PreviewItem(
                      label: 'Customer Needs',
                      value: text('customerNeeds'),
                    ),
                    PreviewItem(
                      label: 'Competitors',
                      value: text('competitors'),
                    ),
                    PreviewItem(
                      label: 'Competitive Advantage',
                      value: text('competitiveAdvantage'),
                    ),
                  ],
                ),

                PlanPreviewSection(
                  icon: Icons.campaign_outlined,
                  title: 'Marketing & Sales',
                  items: [
                    PreviewItem(
                      label: 'Marketing Strategy',
                      value: text('marketingStrategy'),
                    ),
                    PreviewItem(
                      label: 'Sales Strategy',
                      value: text('salesStrategy'),
                    ),
                  ],
                ),

                PlanPreviewSection(
                  icon: Icons.payments_outlined,
                  title: 'Financial Plan',
                  items: [
                    PreviewItem(
                      label: 'Startup Cost',
                      value: 'R ${amount('startupCost').toStringAsFixed(2)}',
                    ),
                    PreviewItem(
                      label: 'Expected Monthly Income',
                      value:
                          'R ${amount('expectedMonthlyIncome').toStringAsFixed(2)}',
                    ),
                    PreviewItem(
                      label: 'Expected Monthly Expenses',
                      value:
                          'R ${amount('expectedMonthlyExpenses').toStringAsFixed(2)}',
                    ),
                    PreviewItem(
                      label: 'Expected Monthly Profit',
                      value: 'R ${monthlyProfit.toStringAsFixed(2)}',
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // DOWNLOAD BUSINESS PLAN AS PDF
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: saving
                        ? null
                        : () async {
                            try {
                              await BusinessPlanPdfService.exportPdf(
                                widget.draft,
                              );
                            } catch (error) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Could not generate PDF: $error',
                                  ),
                                ),
                              );
                            }
                          },
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Download Business Plan as PDF'),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: saving ? null : () => Navigator.pop(context),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: saving ? null : savePlan,
                        icon: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.cloud_done_outlined),
                        label: Text(
                          saving ? 'Saving...' : 'Save Business Plan',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanPreviewSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<PreviewItem> items;

  const PlanPreviewSection({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.darkGreen),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.value,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewItem {
  final String label;
  final String value;

  const PreviewItem({required this.label, required this.value});
}
