import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart' ;
import '../theme/app_theme.dart' ;

class FocusSummaryScreen extends StatelessWidget {
  const FocusSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusProvider>();
    final sessions = focus.sessions;
    final totalPomodoros =
        sessions.fold<int>(0, (sum, s) => sum + s.completedPomodoros);
    final totalMinutes =
        sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatCard(
                  label: 'Pomodoros',
                  value: '$totalPomodoros',
                  icon: Icons.timer_rounded,
                  color: AppColors.deepCoral,
                ),
                const SizedBox(width: 14),
                _StatCard(
                  label: 'Minutes',
                  value: '$totalMinutes',
                  icon: Icons.access_time_rounded,
                  color: AppColors.purple,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _StatCard(
                  label: 'Sessions',
                  value: '${sessions.length}',
                  icon: Icons.bolt_rounded,
                  color: AppColors.teal,
                ),
                const SizedBox(width: 14),
                _StatCard(
                  label: 'This Week',
                  value: '${sessions.where((s) {
                    return s.startTime.isAfter(
                        DateTime.now().subtract(const Duration(days: 7)));
                  }).length}',
                  icon: Icons.calendar_view_week_rounded,
                  color: AppColors.orange,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Recent Sessions',
                style:
                    GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (sessions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Icon(Icons.hourglass_empty_rounded,
                          size: 60,
                          color: AppColors.slateGrey.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Text('No sessions yet',
                          style: GoogleFonts.inter(color: AppColors.slateGrey)),
                      const SizedBox(height: 4),
                      Text('Start a Pomodoro to begin tracking',
                          style: GoogleFonts.inter(
                              color: AppColors.slateGrey, fontSize: 12)),
                    ],
                  ),
                ),
              )
            else
              ...sessions.take(10).map((s) {
                final date = s.startTime;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.deepCoral.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.deepCoral.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.deepCoral.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.timer_rounded,
                            color: AppColors.deepCoral, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${s.durationMinutes} min session',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            Text(
                              '${date.day}/${date.month}/${date.year} · ${s.completedPomodoros} pomodoros',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.slateGrey),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        s.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: s.isCompleted
                            ? AppColors.success
                            : AppColors.slateGrey,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 28, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.slateGrey)),
          ],
        ),
      ),
    );
  }
}
