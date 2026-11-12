import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';
import '../home/home_screen.dart';

class EntrepreneurProfileScreen extends StatefulWidget {
  const EntrepreneurProfileScreen({super.key});

  @override
  State<EntrepreneurProfileScreen> createState() =>
      _EntrepreneurProfileScreenState();
}

class _EntrepreneurProfileScreenState extends State<EntrepreneurProfileScreen> {
  final locationController = TextEditingController();
  final qualificationController = TextEditingController();
  final businessIdeaController = TextEditingController();

  String? industry;
  String? stage;

  bool loading = false;

  final industries = [
    'Agriculture',
    'Technology',
    'Retail',
    'Food & Catering',
    'Beauty',
    'Construction',
    'Transport',
    'Tourism',
    'Education',
    'Other',
  ];

  final stages = [
    'I only have an idea',
    'I am researching my idea',
    'I have started planning',
    'My business is already operating',
  ];

  Future<void> saveProfile() async {
    if (locationController.text.trim().isEmpty ||
        businessIdeaController.text.trim().isEmpty ||
        industry == null ||
        stage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the required information.'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirestoreService().updateEntrepreneurProfile(
        location: locationController.text,
        qualification: qualificationController.text,
        businessIdea: businessIdeaController.text,
        industry: industry!,
        businessStage: stage!,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save your profile.')),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    qualificationController.dispose();
    businessIdeaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Your Journey')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us about yourself',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This helps Rural Spark personalise your startup journey.',
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Town / Area',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: qualificationController,
                  decoration: const InputDecoration(
                    labelText: 'Skills or qualification (optional)',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: industry,
                  decoration: const InputDecoration(
                    labelText: 'Business industry',
                  ),
                  items: industries
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => industry = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: businessIdeaController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Describe your business idea',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: stage,
                  decoration: const InputDecoration(
                    labelText: 'Where are you currently?',
                  ),
                  items: stages
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => stage = value);
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: loading ? null : saveProfile,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create My Startup Journey'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
