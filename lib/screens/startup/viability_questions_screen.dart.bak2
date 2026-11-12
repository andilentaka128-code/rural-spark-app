import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'viability_result_screen.dart';

class ViabilityQuestionsScreen extends StatefulWidget {
  const ViabilityQuestionsScreen({super.key});

  @override
  State<ViabilityQuestionsScreen> createState() =>
      _ViabilityQuestionsScreenState();
}

class _ViabilityQuestionsScreenState extends State<ViabilityQuestionsScreen> {
  int currentQuestion = 0;

  final List<int?> answers = List<int?>.filled(5, null);

  final List<Map<String, dynamic>> questions = [
    {
      'title': 'Market Demand',
      'question':
          'How confident are you that people need your product or service?',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Target Customers',
      'question': 'How clearly do you understand who your customers are?',
      'icon': Icons.people_outline,
    },
    {
      'title': 'Competition',
      'question': 'How well do you understand your competitors and what will make your business different?',
      'icon': Icons.storefront_outlined,
    },
    {
      'title': 'Skills & Knowledge',
      'question': 'How prepared are you with the skills or knowledge needed to run this business?',
      'icon': Icons.psychology_outlined,
    },
    {
      'title': 'Startup Finance',
      'question':
          'How prepared are you for the costs of starting this business?',
      'icon': Icons.account_balance_wallet_outlined,
    },
  ];

  final List<String> answerLabels = [
    'Not prepared',
    'A little prepared',
    'Somewhat prepared',
    'Well prepared',
    'Very prepared',
  ];

  void nextQuestion() {
    if (answers[currentQuestion] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an answer.')));
      return;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      final scores = answers.map((answer) => answer!).toList();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ViabilityResultScreen(
            demandScore: scores[0],
            customerScore: scores[1],
            competitionScore: scores[2],
            skillsScore: scores[3],
            financeScore: scores[4],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: const Text('Idea Assessment')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${currentQuestion + 1} of ${questions.length}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: (currentQuestion + 1) / questions.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),

                const SizedBox(height: 35),

                Center(
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.lightGreen,
                    child: Icon(
                      question['icon'] as IconData,
                      size: 38,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    question['title'],
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  question['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                ),

                const SizedBox(height: 30),

                ...List.generate(5, (index) {
                  final score = index + 1;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<int>(
                      value: score,
                      groupValue: answers[currentQuestion],
                      title: Text(answerLabels[index]),
                      subtitle: Text('Score: $score / 5'),
                      activeColor: AppColors.darkGreen,
                      onChanged: (value) {
                        setState(() {
                          answers[currentQuestion] = value;
                        });
                      },
                    ),
                  );
                }),

                const SizedBox(height: 20),

                Row(
                  children: [
                    if (currentQuestion > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              currentQuestion--;
                            });
                          },
                          child: const Text('Back'),
                        ),
                      ),

                    if (currentQuestion > 0) const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: nextQuestion,
                        child: Text(
                          currentQuestion == questions.length - 1
                              ? 'See My Result'
                              : 'Next',
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
    );
  }
}
