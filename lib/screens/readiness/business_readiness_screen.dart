import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BusinessReadinessScreen extends StatefulWidget {
  const BusinessReadinessScreen({super.key});

  @override
  State<BusinessReadinessScreen> createState() =>
      _BusinessReadinessScreenState();
}

class _BusinessReadinessScreenState extends State<BusinessReadinessScreen> {
  bool _loading = true;
  String? _error;
  int _score = 0;

  final List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _calculateReadiness();
  }

  bool _hasValue(dynamic value) {
    return value != null && value.toString().trim().isNotEmpty;
  }

  void _addCheck({
    required String title,
    required bool completed,
    required int points,
    required String advice,
  }) {
    if (completed) {
      _score += points;
    }

    _results.add({
      'title': title,
      'completed': completed,
      'points': points,
      'advice': advice,
    });
  }

  Future<void> _calculateReadiness() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Please log in first.');
      }

      final db = FirebaseFirestore.instance;

      // Entrepreneur profile
      final userSnapshot = await db.collection('users').doc(user.uid).get();

      final profile = userSnapshot.data() ?? <String, dynamic>{};

      // Business plan
      final planSnapshot = await db
          .collection('business_plans')
          .doc(user.uid)
          .get();

      final plan = planSnapshot.data() ?? <String, dynamic>{};

      // Goals
      final goalsSnapshot = await db
          .collection('goals')
          .where('userId', isEqualTo: user.uid)
          .get();

      _score = 0;
      _results.clear();

      // 1. Entrepreneur Profile - 10
      _addCheck(
        title: 'Entrepreneur Profile',
        completed:
            _hasValue(profile['businessIdea']) &&
            _hasValue(profile['industry']) &&
            _hasValue(profile['province']) &&
            _hasValue(profile['businessStage']),
        points: 10,
        advice: 'Complete your entrepreneur profile.',
      );

      // 2. Business Assessment - 15
      _addCheck(
        title: 'Business Idea Assessment',
        completed: profile['viabilityCompleted'] == true,
        points: 15,
        advice: 'Complete and save your business idea assessment.',
      );

      // 3. Market Research - 10
      _addCheck(
        title: 'Market Research',
        completed:
            _hasValue(plan['targetCustomers']) &&
            _hasValue(plan['competitors']),
        points: 10,
        advice: 'Identify your target customers and competitors.',
      );

      // 4. Business Plan - 25
      _addCheck(
        title: 'Business Plan',
        completed:
            profile['businessPlanCompleted'] == true && planSnapshot.exists,
        points: 25,
        advice: 'Create and save your business plan.',
      );

      // 5. Startup Costs - 10
      final startupCost = plan['startupCost'];

      _addCheck(
        title: 'Startup Costs',
        completed: startupCost is num && startupCost > 0,
        points: 10,
        advice: 'Estimate how much money you need to start.',
      );

      // 6. Funding Preparation - 10
      _addCheck(
        title: 'Funding Preparation',
        completed: profile['fundingPrepared'] == true,
        points: 10,
        advice: 'Review funding requirements and prepare your documents.',
      );

      // 7. Registration Preparation - 10
      _addCheck(
        title: 'Registration Preparation',
        completed: profile['registrationCompleted'] == true,
        points: 10,
        advice: 'Complete your business registration checklist.',
      );

      // 8. My Goals - 10
      _addCheck(
        title: 'My Goals',
        completed: goalsSnapshot.docs.isNotEmpty,
        points: 10,
        advice: 'Create at least one startup goal.',
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String get _status {
    if (_score < 40) return 'Getting Started';
    if (_score < 70) return 'Still Preparing';
    if (_score < 90) return 'Making Good Progress';
    return 'Well Prepared';
  }

  String get _message {
    if (_score < 40) {
      return 'You are at an early stage. Start by developing your business idea and completing your assessment.';
    }

    if (_score < 70) {
      return 'You have made progress, but important preparations are still missing.';
    }

    if (_score < 90) {
      return 'You are making good progress. Review the remaining recommendations.';
    }

    return 'You have completed most of the preparation activities. Review market demand, finances and legal requirements before launching.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Readiness'),
        backgroundColor: const Color(0xFFE2EEE9),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(_error!),
              ),
            )
          : RefreshIndicator(
              onRefresh: _calculateReadiness,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Icon(
                    Icons.fact_check_outlined,
                    size: 60,
                    color: Color(0xFF00543F),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your Business Readiness',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$_score%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00543F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _score / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF00543F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_message, textAlign: TextAlign.center),
                  const SizedBox(height: 28),
                  const Text(
                    'Your Preparation Checklist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ..._results.map((item) {
                    final completed = item['completed'] as bool;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Icon(
                          completed
                              ? Icons.check_circle
                              : Icons.warning_amber_rounded,
                          color: completed ? Colors.green : Colors.orange,
                        ),
                        title: Text(item['title'] as String),
                        subtitle: Text(
                          completed ? 'Completed' : item['advice'] as String,
                        ),
                        trailing: Text(
                          completed
                              ? '+${item['points']}'
                              : '0/${item['points']}',
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _calculateReadiness,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh My Readiness Score'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00543F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'This score measures your recorded business preparation. '
                    'It does not guarantee business success, funding approval '
                    'or legal compliance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
