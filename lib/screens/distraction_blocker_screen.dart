import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart' ;
import '../theme/app_theme.dart' ;

class DistractionBlockerScreen extends StatelessWidget {
  const DistractionBlockerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distraction Blocker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: focus.isBlockerEnabled
                      ? [AppColors.deepCoral, const Color(0xFFD94247)]
                      : [AppColors.slateGrey, const Color(0xFF4A5568)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.block_rounded, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          focus.isBlockerEnabled
                              ? 'Blocker Active'
                              : 'Blocker Off',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          focus.isBlockerEnabled
                              ? 'Distractions blocked. Stay focused!'
                              : 'Enable to silence notifications.',
                          style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: focus.isBlockerEnabled,
                    onChanged: (_) => focus.toggleBlocker(),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('What\'s blocked',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...const [
              ['Notifications', Icons.notifications_off_rounded],
              ['Social Media Alerts', Icons.people_alt_rounded],
              ['Email Badges', Icons.email_rounded],
              ['Background Sounds', Icons.volume_off_rounded],
            ].map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: focus.isBlockerEnabled
                      ? AppColors.deepCoral.withOpacity(0.06)
                      : AppColors.slateLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: focus.isBlockerEnabled
                        ? AppColors.deepCoral.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(item[1] as IconData,
                        color: focus.isBlockerEnabled
                            ? AppColors.deepCoral
                            : AppColors.slateGrey,
                        size: 20),
                    const SizedBox(width: 14),
                    Text(item[0] as String,
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Icon(
                      focus.isBlockerEnabled
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: focus.isBlockerEnabled
                          ? AppColors.success
                          : AppColors.slateGrey,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
