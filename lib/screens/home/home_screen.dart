import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../services/auth_service.dart';
import '../ai_coach/ai_business_coach_screen.dart';
import '../auth/login_screen.dart';
import '../business_plan/business_plan_screen.dart';
import '../funding/funding_screen.dart';
import '../goals/goals_screen.dart';
import '../profile/entrepreneur_profile_screen.dart';
import '../readiness/business_readiness_screen.dart';
import '../registration/business_registration_screen.dart';
import '../startup/start_business_screen.dart';
import '../support/business_support_screen.dart';
import 'startup_journey_screen.dart';

const _forest = Color(0xFF064D3A);
const _green = Color(0xFF087E60);
const _pale = Color(0xFFE8F5EE);
const _ink = Color(0xFF17231F);
const _muted = Color(0xFF63756D);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginScreen();

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco_rounded, color: _forest, size: 30),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Rural Spark',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _forest,
                  fontWeight: FontWeight.w800,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'My Profile',
            icon: const Icon(Icons.account_circle_outlined, color: _forest),
            onPressed: () => _open(context, const EntrepreneurProfileScreen()),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_outlined, color: _forest),
            onPressed: () => logout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() ?? <String, dynamic>{};
          final businessIdea = data['businessIdea']?.toString() ?? '';
          final flags = <bool>[
            data['profileCompleted'] == true,
            data['viabilityCompleted'] == true,
            data['businessPlanCompleted'] == true,
            data['registrationCompleted'] == true,
            data['fundingCompleted'] == true,
            data['goalsCompleted'] == true,
          ];
          final completed = flags.where((flag) => flag).length;
          final progress = completed / flags.length;
          final percent = (progress * 100).round();

          final steps = <_JourneyStep>[
            _JourneyStep(
              number: 1,
              title: 'Start Your Business',
              subtitle: 'Explore your idea and learn what to do first.',
              icon: Icons.storefront_outlined,
              image: 'assets/rural_home/start.jpg',
              done: flags[1],
              onTap: () => _open(context, const StartBusinessScreen()),
            ),
            _JourneyStep(
              number: 2,
              title: 'Create Your Plan',
              subtitle: 'Build a simple plan with step-by-step guidance.',
              icon: Icons.description_outlined,
              image: 'assets/rural_home/plan.jpg',
              done: flags[2],
              onTap: () => _open(context, const BusinessPlanScreen()),
            ),
            _JourneyStep(
              number: 3,
              title: 'Find Funding',
              subtitle: 'Discover opportunities for your business.',
              icon: Icons.savings_outlined,
              image: 'assets/rural_home/funding.jpg',
              done: flags[4],
              onTap: () => _open(context, const FundingScreen()),
            ),
            _JourneyStep(
              number: 4,
              title: 'Business Registration',
              subtitle: 'Learn how to register your business.',
              icon: Icons.verified_outlined,
              image: 'assets/rural_home/registration.jpg',
              done: flags[3],
              onTap: () => _open(context, const BusinessRegistrationScreen()),
            ),
            _JourneyStep(
              number: 5,
              title: 'Set Your Goals',
              subtitle: 'Set targets and track your progress.',
              icon: Icons.track_changes_outlined,
              image: 'assets/rural_home/goals.jpg',
              done: flags[5],
              onTap: () => _open(context, const GoalsScreen()),
            ),
            _JourneyStep(
              number: 6,
              title: 'Get Support',
              subtitle: 'Find guidance, tools and business help.',
              icon: Icons.support_agent_outlined,
              image: 'assets/rural_home/support.jpg',
              done: false,
              onTap: () => _open(context, const BusinessSupportScreen()),
            ),
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroBanner(
                          businessIdea: businessIdea,
                          onContinue: () =>
                              _open(context, const StartupJourneyScreen()),
                        )
                        .animate()
                        .fadeIn(duration: 450.ms)
                        .slideY(begin: .08, end: 0, duration: 450.ms),
                    const SizedBox(height: 20),
                    _ProgressCard(
                      completed: completed,
                      total: flags.length,
                      progress: progress,
                      percent: percent,
                      onTap: () => _open(context, const StartupJourneyScreen()),
                    ).animate().fadeIn(delay: 120.ms, duration: 450.ms),
                    const SizedBox(height: 28),
                    const Text(
                      'Business Journey',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Follow these simple steps to start and grow your business.',
                      style: TextStyle(color: _muted, fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final columns = width >= 920
                            ? 3
                            : width >= 590
                            ? 2
                            : 1;
                        const gap = 14.0;
                        final itemWidth =
                            (width - (columns - 1) * gap) / columns;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final step in steps)
                              SizedBox(
                                width: itemWidth,
                                child: _JourneyCard(step: step),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'More Ways to Grow',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ExtraAction(
                      icon: Icons.auto_awesome_outlined,
                      title: 'AI Business Coach',
                      subtitle: 'Ask questions and get business guidance.',
                      onTap: () =>
                          _open(context, const AiBusinessCoachScreen()),
                    ),
                    const SizedBox(height: 10),
                    _ExtraAction(
                      icon: Icons.fact_check_outlined,
                      title: 'Business Readiness',
                      subtitle: 'Check how ready your business is.',
                      onTap: () =>
                          _open(context, const BusinessReadinessScreen()),
                    ),
                    const SizedBox(height: 10),
                    _ExtraAction(
                      icon: Icons.person_outline,
                      title: 'Complete Your Profile',
                      subtitle: 'Keep your entrepreneur details up to date.',
                      onTap: () =>
                          _open(context, const EntrepreneurProfileScreen()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final String businessIdea;
  final VoidCallback onContinue;

  const _HeroBanner({required this.businessIdea, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_forest, _green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/rural_home/hero.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _forest,
                    _forest.withValues(alpha: .98),
                    _forest.withValues(alpha: .65),
                    _forest.withValues(alpha: .03),
                  ],
                  stops: const [0, .36, .67, 1],
                ),
              ),
            ),
          ),
          Positioned(
            right: -55,
            top: -75,
            child: _DecorCircle(size: 240, opacity: .08),
          ),
          Positioned(
            right: 60,
            bottom: -90,
            child: _DecorCircle(size: 180, opacity: .08),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 600;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Build Your Business\nStep by Step',
                            style: TextStyle(
                              fontSize: 30,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 13),
                          const Text(
                            'Get guidance, create a plan, find funding '
                            'and turn your ideas into a business.',
                            style: TextStyle(
                              color: Color(0xFFE0F5EC),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          if (businessIdea.trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Your idea: $businessIdea',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 22),
                          ElevatedButton.icon(
                            onPressed: onContinue,
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Continue Your Journey'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: _forest,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 15,
                              ),
                              shape: const StadiumBorder(),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (wide) const SizedBox(width: 200),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecorCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: opacity),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: -8, end: 8, duration: 2800.ms);
  }
}

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;
  final int percent;
  final VoidCallback onTap;

  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
    required this.percent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE1EEE6)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 550;
              final heading = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 21,
                      color: _ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Complete your startup journey.',
                    style: TextStyle(color: _muted, fontSize: 13),
                  ),
                ],
              );
              final bar = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 11,
                            color: _forest,
                            backgroundColor: const Color(0xFFE5ECE8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: _forest,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '$completed of $total startup milestones completed',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              );
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [heading, const SizedBox(height: 19), bar],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 2, child: heading),
                  const SizedBox(width: 20),
                  Expanded(flex: 3, child: bar),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _JourneyStep {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  final String image;
  final bool done;
  final VoidCallback onTap;

  const _JourneyStep({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.image,
    required this.done,
    required this.onTap,
  });
}

class _JourneyCard extends StatelessWidget {
  final _JourneyStep step;
  const _JourneyCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: step.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 172),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE1EEE6)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  step.image,
                  width: 92,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 92,
                    height: 120,
                    color: _pale,
                    child: Icon(step.icon, size: 42, color: _forest),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: _pale,
                          child: Text(
                            '${step.number}',
                            style: const TextStyle(
                              color: _forest,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (step.done) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.check_circle,
                            size: 18,
                            color: _green,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      step.title,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      step.subtitle,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: _pale,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 17,
                          color: _forest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtraAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExtraAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1EEE6)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _pale,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _forest),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: _forest, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
