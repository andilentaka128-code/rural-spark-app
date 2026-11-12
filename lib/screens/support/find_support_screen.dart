import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class FindSupportScreen extends StatefulWidget {
  const FindSupportScreen({super.key});

  @override
  State<FindSupportScreen> createState() => _FindSupportScreenState();
}

class _FindSupportScreenState extends State<FindSupportScreen> {
  String selectedCategory = 'All';

  final List<SupportCategory> categories = const [
    SupportCategory(name: 'All', icon: Icons.apps),
    SupportCategory(
      name: 'Funding',
      icon: Icons.account_balance_wallet_outlined,
    ),
    SupportCategory(name: 'Registration', icon: Icons.description_outlined),
    SupportCategory(name: 'Training', icon: Icons.school_outlined),
    SupportCategory(
      name: 'Business Advice',
      icon: Icons.business_center_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.veryLightGreen,
      appBar: AppBar(
        title: const Text(
          'Find Business Support',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // INTRODUCTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 34,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Find help near you',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Find business support services for funding, '
                          'registration, training and business advice.',
                          style: TextStyle(color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'What help are you looking for?',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 14),

                  // SUPPORT CATEGORIES
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((category) {
                      final selected = selectedCategory == category.name;

                      return ChoiceChip(
                        selected: selected,
                        showCheckmark: false,
                        avatar: Icon(
                          category.icon,
                          size: 19,
                          color: selected ? Colors.white : AppColors.darkGreen,
                        ),
                        label: Text(category.name),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: AppColors.darkGreen,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category.name;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // MAP PLACEHOLDER
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 65,
                          color: AppColors.darkGreen,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Business Support Map',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: 7),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Your location and nearby business '
                            'support services will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Business Support Near You',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Nearby support centres will appear here '
                    'after location access is enabled.',
                    style: TextStyle(color: AppColors.grey),
                  ),

                  const SizedBox(height: 18),

                  // LOCATION BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Location and real map are the next step.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text('Use My Location'),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        size: 18,
                        color: AppColors.grey,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your location will only be used to help '
                          'find relevant business support near you.',
                          style: TextStyle(color: AppColors.grey, fontSize: 12),
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

class SupportCategory {
  final String name;
  final IconData icon;

  const SupportCategory({required this.name, required this.icon});
}
