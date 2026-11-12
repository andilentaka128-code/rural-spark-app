import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';

class ViabilityResultScreen extends StatefulWidget {
  final int demandScore;
  final int customerScore;
  final int competitionScore;
  final int skillsScore;
  final int financeScore;

  const ViabilityResultScreen({
    super.key,
    required this.demandScore,
    required this.customerScore,
    required this.competitionScore,
    required this.skillsScore,
    required this.financeScore,
  });

  @override
  State<ViabilityResultScreen> createState() => _ViabilityResultScreenState();
}

class _ViabilityResultScreenState extends State<ViabilityResultScreen> {
  bool saving = false;
  bool saved = false;

  int get totalScore =>
      widget.demandScore +
      widget.customerScore +
      widget.competitionScore +
      widget.skillsScore +
      widget.financeScore;

  int get percentage => ((totalScore / 25) * 100).round();

  String get resultTitle {
    if (percentage >= 80) {
      return 'Strong Foundation';
    }

    if (percentage >= 60) {
      return 'Promising Idea';
    }

    if (percentage >= 40) {
      return 'Needs More Planning';
    }

    return 'More Research Needed';
  }

  String get recommendation {
    if (percentage >= 80) {
      return 'Your answers show a strong starting foundation. '
          'Your next step is to develop a structured business plan '
          'and confirm your assumptions with real customers.';
    }

    if (percentage >= 60) {
      return 'Your idea shows potential, but there are still areas '
          'that need attention. Focus on your lowest-scoring areas '
          'before investing significant money.';
    }

    if (percentage >= 40) {
      return 'Your idea may have potential, but you should do more '
          'research and planning. Speak to potential customers, '
          'study competitors and estimate your startup costs.';
    }

    return 'Do not rush into spending money yet. Start by learning '
        'more about your customers, the problem you want to solve, '
        'your competitors and the resources required.';
  }

  Future<void> saveAssessment() async {
    if (saved) return;

    setState(() => saving = true);

    try {
      await FirestoreService().saveViabilityAssessment(
        demandScore: widget.demandScore,
        customerScore: widget.customerScore,
        competitionScore: widget.competitionScore,
        skillsScore: widget.skillsScore,
        financeScore: widget.financeScore,
        totalScore: percentage,
        recommendation: recommendation,
      );

      if (!mounted) return;

      setState(() {
        saved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assessment saved successfully.')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save assessment.')),
      );
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  Widget scoreRow(String title, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            '$score / 5',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Result')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              children: [
                const Text(
                  'Your Idea Viability Score',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  resultTitle,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        scoreRow('Market Demand', widget.demandScore),
                        scoreRow('Target Customers', widget.customerScore),
                        scoreRow('Competition', widget.competitionScore),
                        scoreRow('Skills & Knowledge', widget.skillsScore),
                        scoreRow('Startup Finance', widget.financeScore),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rural Spark Recommendation',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(recommendation, style: const TextStyle(height: 1.5)),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton.icon(
                  onPressed: saving || saved ? null : saveAssessment,
                  icon: Icon(saved ? Icons.check : Icons.save_outlined),
                  label: Text(
                    saving
                        ? 'Saving...'
                        : saved
                        ? 'Assessment Saved'
                        : 'Save My Assessment',
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false,
                    );
                  },
                  child: const Text('Return to Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
