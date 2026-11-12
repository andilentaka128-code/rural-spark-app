import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class CustomBusinessGapAnalysis extends StatelessWidget {
  final String location;
  final String skills;
  final String businessIdea;

  const CustomBusinessGapAnalysis({
    super.key,
    required this.location,
    required this.skills,
    required this.businessIdea,
  });

  String get _possibleGap {
    final idea = businessIdea.toLowerCase();

    if (idea.contains('bake') ||
        idea.contains('bread') ||
        idea.contains('cake')) {
      return 'Investigate whether customers need affordable baked goods, '
          'early-morning bread sales, event orders or local delivery.';
    }

    if (idea.contains('food') ||
        idea.contains('cook') ||
        idea.contains('catering')) {
      return 'Investigate demand for affordable meals, convenient '
          'ordering, food delivery or catering for small events.';
    }

    if (idea.contains('phone') ||
        idea.contains('computer') ||
        idea.contains('technology')) {
      return 'Investigate whether residents struggle to access '
          'affordable device repairs or nearby digital services.';
    }

    if (idea.contains('farm') ||
        idea.contains('vegetable') ||
        idea.contains('chicken')) {
      return 'Investigate whether households and local businesses '
          'need reliable access to fresh agricultural products.';
    }

    if (idea.contains('hair') ||
        idea.contains('salon') ||
        idea.contains('beauty')) {
      return 'Investigate whether customers need convenient appointments, '
          'home services or affordable beauty packages.';
    }

    if (idea.contains('sew') ||
        idea.contains('clothing') ||
        idea.contains('fashion')) {
      return 'Investigate demand for affordable clothing repairs, '
          'uniform alterations or custom-made garments.';
    }

    return 'Investigate which customer needs are not being fully met '
        'by existing businesses in your selected area. '
        'Compare prices, convenience, service quality and accessibility.';
  }

  String get _howToBeDifferent {
    final idea = businessIdea.toLowerCase();

    if (idea.contains('bake') ||
        idea.contains('bread') ||
        idea.contains('cake')) {
      return 'Consider pre-orders, small affordable packs, '
          'special-event baking or local delivery.';
    }

    if (idea.contains('food') ||
        idea.contains('cook') ||
        idea.contains('catering')) {
      return 'Consider meal subscriptions, WhatsApp ordering, '
          'affordable lunch packages or small-event catering.';
    }

    if (idea.contains('phone') ||
        idea.contains('computer') ||
        idea.contains('technology')) {
      return 'Consider transparent repair prices, collection services, '
          'quick diagnostics or convenient customer support.';
    }

    if (idea.contains('farm') ||
        idea.contains('vegetable') ||
        idea.contains('chicken')) {
      return 'Consider pre-orders, regular supply arrangements '
          'or affordable household bundles.';
    }

    if (idea.contains('hair') ||
        idea.contains('salon') ||
        idea.contains('beauty')) {
      return 'Consider mobile appointments, clear pricing '
          'and flexible booking times.';
    }

    if (idea.contains('sew') ||
        idea.contains('clothing') ||
        idea.contains('fashion')) {
      return 'Consider collection and delivery, uniform repair '
          'packages or clear turnaround times.';
    }

    return 'Consider offering better convenience, clearer prices, '
        'more accessible services or a specialised product '
        'for an underserved customer group.';
  }

  @override
  Widget build(BuildContext context) {
    if (businessIdea.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.lightGreen,
      margin: const EdgeInsets.only(top: 18, bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Business Idea Analysis',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 14),
            Text('Business idea: $businessIdea'),
            const SizedBox(height: 8),
            Text('Location: $location'),
            if (skills.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Your skills: $skills'),
            ],
            const SizedBox(height: 20),
            const Text(
              'Possible Market Gap',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(_possibleGap),
            const SizedBox(height: 20),
            const Text(
              'How Your Business Could Be Different',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(_howToBeDifferent),
            const SizedBox(height: 20),
            const Text(
              'Next Step',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search for similar businesses in your area. '
              'Ask potential customers what they need, '
              'compare competitors and test whether your idea '
              'solves a real problem.',
            ),
            const SizedBox(height: 16),
            const Text(
              'These are suggestions to investigate, not verified '
              'market gaps or findings about existing competitors.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
