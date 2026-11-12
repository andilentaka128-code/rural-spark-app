import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'funding_opportunities_screen.dart';

class FundingReadinessScreen extends StatefulWidget {
  const FundingReadinessScreen({super.key});

  @override
  State<FundingReadinessScreen> createState() => _FundingReadinessScreenState();
}

class _FundingReadinessScreenState extends State<FundingReadinessScreen> {
  bool hasBusinessPlan = false;
  bool knowsFundingAmount = false;
  bool knowsFundingPurpose = false;
  bool hasFinancialEstimate = false;
  bool hasSupportingDocuments = false;

  final TextEditingController locationController = TextEditingController();
  bool isRegistered = false;

  int get score => [
    hasBusinessPlan,
    knowsFundingAmount,
    knowsFundingPurpose,
    hasFinancialEstimate,
    hasSupportingDocuments,
  ].where((answer) => answer).length;

  int get percentage => score * 20;

  String get message {
    if (score >= 4) {
      return 'You have prepared many important items. '
          'Explore funding programmes that may suit you.';
    }
    if (score >= 2) {
      return 'You are making progress. Explore funding '
          'options and see what you still need to prepare.';
    }
    return 'You can explore funding and business support '
        'while preparing your business documents.';
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  void findFunding() {
    final location = locationController.text.trim();

    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your town or village.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FundingOpportunitiesScreen(
          readinessScore: percentage,
          location: location,
          isRegistered: isRegistered,
          hasBusinessPlan: hasBusinessPlan,
          knowsFundingAmount: knowsFundingAmount,
          knowsFundingPurpose: knowsFundingPurpose,
          hasFinancialEstimate: hasFinancialEstimate,
          hasSupportingDocuments: hasSupportingDocuments,
        ),
      ),
    );
  }

  bool _loadingFunding = true;
  bool _savingFunding = false;

  @override
  void initState() {
    super.initState();
    _loadFundingProgress();
  }

  Future<void> _loadFundingProgress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() => _loadingFunding = false);
        }
        return;
      }

      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = document.data() ?? <String, dynamic>{};

      if (!mounted) return;

      setState(() {
        hasBusinessPlan = data['fundingHasBusinessPlan'] == true;
        knowsFundingAmount = data['fundingKnowsAmount'] == true;
        knowsFundingPurpose = data['fundingKnowsPurpose'] == true;
        hasFinancialEstimate = data['fundingHasFinancialEstimate'] == true;
        hasSupportingDocuments = data['fundingHasSupportingDocuments'] == true;
        isRegistered = data['fundingIsRegistered'] == true;

        final savedLocation = data['fundingLocation'];

        if (savedLocation is String) {
          locationController.text = savedLocation;
        }

        _loadingFunding = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _loadingFunding = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load funding progress: $error')),
      );
    }
  }

  Future<void> _saveFundingProgress() async {
    if (_loadingFunding || _savingFunding) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save your progress.')),
      );
      return;
    }

    setState(() => _savingFunding = true);

    final completedCount = [
      hasBusinessPlan,
      knowsFundingAmount,
      knowsFundingPurpose,
      hasFinancialEstimate,
      hasSupportingDocuments,
    ].where((item) => item).length;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fundingHasBusinessPlan': hasBusinessPlan,
        'fundingKnowsAmount': knowsFundingAmount,
        'fundingKnowsPurpose': knowsFundingPurpose,
        'fundingHasFinancialEstimate': hasFinancialEstimate,
        'fundingHasSupportingDocuments': hasSupportingDocuments,
        'fundingIsRegistered': isRegistered,
        'fundingLocation': locationController.text.trim(),
        'fundingReadinessScore': completedCount * 20,
        'fundingPrepared': completedCount == 5,
        'fundingUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Funding progress saved successfully!')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save funding progress: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _savingFunding = false);
      }
    }
  }

  Widget readinessItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.darkGreen,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Funding Readiness')),
      body: _loadingFunding
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Are you ready for funding?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tick each item you have already prepared.',
                        style: TextStyle(color: AppColors.grey),
                      ),
                      const SizedBox(height: 22),

                      readinessItem(
                        title: 'I have a business plan',
                        description:
                            'I can explain how my business will operate.',
                        value: hasBusinessPlan,
                        onChanged: (value) {
                          setState(() {
                            hasBusinessPlan = value ?? false;
                          });
                        },
                      ),

                      readinessItem(
                        title: 'I know how much funding I need',
                        description: 'I have estimated the amount required.',
                        value: knowsFundingAmount,
                        onChanged: (value) {
                          setState(() {
                            knowsFundingAmount = value ?? false;
                          });
                        },
                      ),

                      readinessItem(
                        title: 'I know what the funding will be used for',
                        description:
                            'For example, equipment, stock or operating costs.',
                        value: knowsFundingPurpose,
                        onChanged: (value) {
                          setState(() {
                            knowsFundingPurpose = value ?? false;
                          });
                        },
                      ),

                      readinessItem(
                        title: 'I have financial estimates',
                        description:
                            'I understand my expected income and expenses.',
                        value: hasFinancialEstimate,
                        onChanged: (value) {
                          setState(() {
                            hasFinancialEstimate = value ?? false;
                          });
                        },
                      ),

                      readinessItem(
                        title: 'I have supporting documents',
                        description: 'I have started preparing documents that may be requested.',
                        value: hasSupportingDocuments,
                        onChanged: (value) {
                          setState(() {
                            hasSupportingDocuments = value ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Tell us about yourself',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: locationController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Business Location',
                          hintText: 'Example: Mthatha, Eastern Cape',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      SwitchListTile(
                        title: const Text('My business is registered'),
                        subtitle: Text(
                          isRegistered
                              ? 'Registered business'
                              : 'Not registered yet',
                        ),
                        value: isRegistered,
                        activeThumbColor: AppColors.darkGreen,
                        onChanged: (value) {
                          setState(() {
                            isRegistered = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGreen,
                              ),
                            ),
                            const Text(
                              'Funding Readiness',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: score / 5,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _savingFunding || _loadingFunding
                              ? null
                              : _saveFundingProgress,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(
                            _savingFunding
                                ? 'Saving...'
                                : 'Save My Funding Progress',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: findFunding,
                          icon: const Icon(Icons.search),
                          label: const Text(
                            'Show Funding Available for Me',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'We will suggest programmes to investigate '
                        'based on your answers. Final eligibility '
                        'and funding approval depend on each provider.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey, fontSize: 12),
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
