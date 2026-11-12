import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  State<BusinessRegistrationScreen> createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  final List<String> _steps = [
    'Choose business structure',
    'Choose business name',
    'Prepare information',
    'Register through CIPC',
    'Understand tax',
    'Check permits',
  ];

  final List<String> _descriptions = [
    'Decide whether to operate as a sole proprietor or register a company.',
    'Choose a suitable business name and check naming requirements.',
    'Prepare the identification documents and business information you need.',
    'Register your company through CIPC if registration is required.',
    'Understand your business tax obligations through SARS.',
    'Check whether your business needs licences or municipal permits.',
  ];

  late List<bool> _completed;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _completed = List.filled(_steps.length, false);

    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < _steps.length; i++) {
      _completed[i] = prefs.getBool('registration_step_$i') ?? false;
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateStep(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('registration_step_$index', value);

    if (!mounted) return;

    setState(() {
      _completed[index] = value;
    });
  }

  Future<void> _openCIPC() async {
    final uri = Uri.parse('https://www.cipc.co.za/');

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open CIPC website.')),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open CIPC website.')),
      );
    }
  }

  Future<void> _findRegistrationHelp() async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': 'business registration assistance near me South Africa',
    });

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _completed.where((step) => step).length;

    final progress = completedCount / _steps.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Registration Guide',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.lightGreen,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      const Icon(
                        Icons.business_center_outlined,
                        size: 65,
                        color: AppColors.darkGreen,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Start Your Business',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Learn how to formalise your business in South Africa.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        'Your Progress: ${(progress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: AppColors.lightGreen,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      const SizedBox(height: 28),

                      ...List.generate(
                        _steps.length,
                        (index) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: CheckboxListTile(
                            value: _completed[index],
                            activeColor: AppColors.darkGreen,
                            title: Text(
                              'Step ${index + 1}: ${_steps[index]}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(_descriptions[index]),
                            ),
                            onChanged: (value) {
                              _updateStep(index, value ?? false);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _openCIPC,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text(
                            'Visit Official CIPC Website',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // GOOGLE MAPS REGISTRATION HELP BUTTON
                      SizedBox(
                        height: 58,
                        child: OutlinedButton.icon(
                          onPressed: _findRegistrationHelp,
                          icon: const Icon(
                            Icons.location_on_outlined,
                            size: 25,
                          ),
                          label: const Text(
                            'Find Registration Help Near Me',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkGreen,
                            backgroundColor: const Color(0xFFE3EEEA),
                            side: const BorderSide(
                              color: Color(0xFF71857D),
                              width: 1.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
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
