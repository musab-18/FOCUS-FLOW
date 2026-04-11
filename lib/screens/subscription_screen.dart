import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart' ;

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const features = [
      (Icons.all_inclusive_rounded, 'Unlimited Projects'),
      (Icons.analytics_rounded, 'Advanced Analytics'),
      (Icons.block_rounded, 'Pro Distraction Blocker'),
      (Icons.sync_rounded, 'Cross-Device Sync'),
      (Icons.color_lens_rounded, 'Custom Themes'),
      (Icons.headphones_rounded, 'Premium Sounds'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Pro'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.deepCoral, AppColors.purple],
                ),
              ),
              child: Column(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text('FocusFlow Pro',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('Unlock your full productivity potential',
                      style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Feature list
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.deepCoral.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(f.$1,
                                  color: AppColors.deepCoral, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Text(f.$2,
                                style: GoogleFonts.inter(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            const Spacer(),
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.success, size: 20),
                          ],
                        ),
                      )),
                  const SizedBox(height: 28),
                  // Plans
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.deepCoral, Color(0xFFFF8A8E)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Annual Plan',
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('\$4.99',
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800)),
                                  Text('/mo',
                                      style: GoogleFonts.inter(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14)),
                                ],
                              ),
                              Text('Billed as \$59.99/year',
                                  style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Save 40%',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                              content: Text('Coming soon! 🚀'))),
                      child: Text('Start Free Trial',
                          style: GoogleFonts.inter(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('7-day free trial, cancel anytime.',
                      style:
                          GoogleFonts.inter(color: AppColors.slateGrey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
