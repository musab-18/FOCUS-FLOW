import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart' ;
import '../providers/task_provider.dart' ;
import '../providers/focus_provider.dart' ;
import '../theme/app_theme.dart' ;

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final tasks = context.watch<TaskProvider>();

    final weeklyData = analytics.weeklyCompletedTasks;
    final totalThisWeek = weeklyData.fold<double>(0, (a, b) => a + b).toInt();
    final focusHrs = (analytics.totalFocusMinutes / 60).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.share_rounded),
              onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.deepCoral, AppColors.purple],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text('Weekly Report',
                      style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('$totalThisWeek',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w800)),
                  Text('tasks completed this week',
                      style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _ReportCard(
                  label: 'Focus Time',
                  value: '$focusHrs hrs',
                  icon: Icons.timer_rounded,
                  color: AppColors.teal,
                ),
                const SizedBox(width: 12),
                _ReportCard(
                  label: 'Pomodoros',
                  value: '${analytics.totalPomodoros}',
                  icon: Icons.bolt_rounded,
                  color: AppColors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ReportCard(
                  label: 'Score',
                  value: '${analytics.productivityScore.toInt()}',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.mediumPriority,
                ),
                const SizedBox(width: 12),
                _ReportCard(
                  label: 'Pending',
                  value: '${tasks.pendingTasks.length}',
                  icon: Icons.pending_rounded,
                  color: AppColors.slateGrey,
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Day-by-day breakdown
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Breakdown',
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  ...List.generate(7, (i) {
                    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    final now = DateTime.now();
                    final d = now.subtract(Duration(days: 6 - i));
                    final label = days[d.weekday - 1];
                    final val = weeklyData[i].toInt();
                    final max = weeklyData
                        .reduce((a, b) => a > b ? a : b)
                        .clamp(1, 100);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 36,
                              child: Text(label,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.slateGrey))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: val / max,
                                backgroundColor:
                                    AppColors.deepCoral.withOpacity(0.08),
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.deepCoral),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 20,
                            child: Text('$val',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ReportCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w800, color: color)),
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.slateGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
