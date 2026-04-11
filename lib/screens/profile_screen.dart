import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' ;
import '../providers/analytics_provider.dart' ;
import '../providers/task_provider.dart' ;
import '../providers/focus_provider.dart' ;
import '../theme/app_theme.dart' ;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final analytics = context.watch<AnalyticsProvider>();
    final tasks = context.watch<TaskProvider>();
    final focus = context.watch<FocusProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Name
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepCoral, Color(0xFFFF8A8E)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(user?.name ?? 'User',
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  Text(user?.email ?? '',
                      style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStat(
                          label: 'Tasks\nDone',
                          value: '${analytics.totalTasksCompleted}'),
                      _Vline(),
                      _ProfileStat(
                          label: 'Focus\nHrs',
                          value: '${(analytics.totalFocusMinutes / 60).toStringAsFixed(1)}'),
                      _Vline(),
                      _ProfileStat(
                          label: 'Streak\nDays',
                          value: '${user?.streakDays ?? 0}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Badges
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Badges',
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _Badge(emoji: '🚀', label: 'First Task', earned: analytics.totalTasksCompleted >= 1),
                      const SizedBox(width: 12),
                      _Badge(emoji: '🔥', label: '5 Pomodoros', earned: analytics.totalPomodoros >= 5),
                      const SizedBox(width: 12),
                      _Badge(emoji: '🏆', label: '10 Tasks', earned: analytics.totalTasksCompleted >= 10),
                      const SizedBox(width: 12),
                      _Badge(emoji: '⚡', label: 'Power User', earned: analytics.totalFocusMinutes >= 120),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Quick links
            _MenuTile(
              icon: Icons.checklist_rounded,
              label: 'All Tasks',
              onTap: () => Navigator.pushNamed(context, '/task-list'),
            ),
            _MenuTile(
              icon: Icons.folder_rounded,
              label: 'Projects',
              onTap: () => Navigator.pushNamed(context, '/projects'),
            ),
            _MenuTile(
              icon: Icons.bar_chart_rounded,
              label: 'Analytics',
              onTap: () => Navigator.pushNamed(context, '/analytics'),
            ),
            _MenuTile(
              icon: Icons.workspace_premium_rounded,
              label: 'Upgrade to Pro',
              onTap: () => Navigator.pushNamed(context, '/subscription'),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.mediumPriority.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('PRO',
                    style: GoogleFonts.inter(
                        color: AppColors.mediumPriority,
                        fontWeight: FontWeight.w700,
                        fontSize: 10)),
              ),
            ),
            _MenuTile(
              icon: Icons.help_outline_rounded,
              label: 'Help & Feedback',
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Sign Out',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      content: Text('Are you sure you want to sign out?',
                          style: GoogleFonts.inter()),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sign Out',
                                style: TextStyle(
                                    color: AppColors.highPriority))),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await context.read<AuthProvider>().signOut();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  }
                },
                icon: const Icon(Icons.logout_rounded,
                    color: AppColors.highPriority),
                label: Text('Sign Out',
                    style: GoogleFonts.inter(
                        color: AppColors.highPriority,
                        fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.highPriority),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        Text(label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11)),
      ],
    );
  }
}

class _Vline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36, width: 1, color: Colors.white.withOpacity(0.3));
  }
}

class _Badge extends StatelessWidget {
  final String emoji;
  final String label;
  final bool earned;
  const _Badge(
      {required this.emoji, required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji,
              style: TextStyle(
                  fontSize: 28,
                  color: earned ? null : const Color(0xFFE2E8F0))),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  color: earned ? AppColors.slateDark : AppColors.slateGrey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _MenuTile(
      {required this.icon,
      required this.label,
      this.onTap,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkCard : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.deepCoral, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded,
                color: AppColors.slateGrey),
          ],
        ),
      ),
    );
  }
}
