import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

const ruralForest = Color(0xFF064E3B);
const ruralMint = Color(0xFFEAF8F1);

class RuralAuthShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> fields;
  final Widget footer;
  final bool showBack;

  const RuralAuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.footer,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 290,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF043B2D), Color(0xFF08755A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(38),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -35,
                          top: -55,
                          child: _Orb(size: 190, opacity: .10),
                        ),
                        Positioned(
                          left: -65,
                          bottom: -70,
                          child: _Orb(size: 165, opacity: .08),
                        ),
                        if (showBack)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Center(
                          child:
                              Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                            width: 82,
                                            height: 82,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: .15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color: Colors.white24,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.eco_rounded,
                                              size: 48,
                                              color: Colors.white,
                                            ),
                                          )
                                          .animate()
                                          .fadeIn(duration: 550.ms)
                                          .scale(begin: const Offset(.75, .75))
                                          .then()
                                          .shimmer(duration: 1300.ms),
                                      const SizedBox(height: 14),
                                      const Text(
                                        'Rural Spark',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -.8,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'From ideas to impact',
                                        style: TextStyle(
                                          color: Color(0xFFD6F5E7),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                  .animate()
                                  .fadeIn(duration: 650.ms)
                                  .slideY(
                                    begin: -.12,
                                    end: 0,
                                    duration: 650.ms,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -26),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child:
                              Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(
                                      22,
                                      28,
                                      22,
                                      24,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(27),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ruralForest.withValues(
                                            alpha: .09,
                                          ),
                                          blurRadius: 28,
                                          offset: const Offset(0, 14),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF142B24),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          subtitle,
                                          style: const TextStyle(
                                            color: Color(0xFF718078),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        ...fields,
                                        const SizedBox(height: 15),
                                        footer,
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: .15, end: 0, duration: 600.ms),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Grow your idea. Build your future.',
                      style: TextStyle(color: Color(0xFF668377), fontSize: 12),
                    ),
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

class _Orb extends StatelessWidget {
  final double size;
  final double opacity;
  const _Orb({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) =>
      Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: opacity),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(begin: -7, end: 7, duration: 2400.ms);
}

InputDecoration ruralInput(String label, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: ruralForest),
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFF8FBF9),
    contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFDCEAE2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFDCEAE2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: ruralForest, width: 1.8),
    ),
  );
}

Widget ruralPrimaryButton({
  required String label,
  required bool loading,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ruralForest,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF679789),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: loading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
    ),
  );
}
