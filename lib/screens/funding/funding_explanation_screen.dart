
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/app_colors.dart';

class FundingExplanationScreen extends StatefulWidget {
  final String organisation;
  final String description;
  final List<String> steps;

  const FundingExplanationScreen({
    super.key,
    required this.organisation,
    required this.description,
    required this.steps,
  });

  @override
  State<FundingExplanationScreen> createState() =>
      _FundingExplanationScreenState();
}

class _FundingExplanationScreenState
    extends State<FundingExplanationScreen> {
  final FlutterTts _tts = FlutterTts();

  int currentStep = 0;
  bool isPlaying = false;
  bool isPaused = false;
  int _session = 0;

  @override
  void initState() {
    super.initState();
    _configureVoice();
  }

  Future<void> _configureVoice() async {
    await _tts.setLanguage('en-ZA');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> playExplanation() async {
    if (widget.steps.isEmpty) return;

    final session = ++_session;
    await _tts.stop();

    if (!mounted || session != _session) return;

    setState(() {
      isPlaying = true;
      isPaused = false;
    });

    for (int i = currentStep; i < widget.steps.length; i++) {
      if (!mounted || session != _session) return;

      setState(() {
        currentStep = i;
      });

      await _tts.speak(
        'Step ${i + 1}. ${widget.steps[i]}',
      );
    }

    if (!mounted || session != _session) return;

    setState(() {
      isPlaying = false;
      isPaused = false;
    });
  }

  Future<void> pauseExplanation() async {
    ++_session;
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      isPaused = true;
    });
  }

  Future<void> replayExplanation() async {
    ++_session;
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      currentStep = 0;
      isPlaying = false;
      isPaused = false;
    });

    await playExplanation();
  }

  @override
  void dispose() {
    ++_session;
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.steps.length;
    final progress =
        total == 0 ? 0.0 : (currentStep + 1) / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Funding Explanation'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to Apply: ${widget.organisation}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.description,
                  style: const TextStyle(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.record_voice_over_outlined,
                        size: 70,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Rural Spark Funding Guide',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        total == 0
                            ? 'No explanation available.'
                            : widget.steps[currentStep],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        total == 0
                            ? 'No steps'
                            : 'Step ${currentStep + 1} of $total',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 12),

                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      const SizedBox(height: 24),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: isPlaying
                                ? pauseExplanation
                                : playExplanation,
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            label: Text(
                              isPlaying
                                  ? 'Pause'
                                  : isPaused
                                      ? 'Resume Step'
                                      : 'Play Explanation',
                            ),
                          ),

                          OutlinedButton.icon(
                            onPressed: replayExplanation,
                            icon: const Icon(Icons.replay),
                            label: const Text('Replay'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Application Steps',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                ...widget.steps.asMap().entries.map((entry) {
                  final active = entry.key == currentStep;

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.lightGreen
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: active
                            ? AppColors.darkGreen
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: AppColors.darkGreen,
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),

                const Text(
                  'This guide explains the general application '
                  'process. Always check the official website '
                  'for current requirements.',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
