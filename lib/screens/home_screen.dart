import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/focus_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/analytics_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/progress_ring.dart';
import '../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>();
    final focus = context.watch<FocusProvider>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().updateData(tasks.tasks, focus.sessions);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: const _HomeTab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-task'),
        backgroundColor: AppColors.deepCoral,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home', true),
              _buildNavItem(1, Icons.calendar_today_rounded, 'Calendar', false),
              const SizedBox(width: 48),
              _buildNavItem(2, Icons.bar_chart_rounded, 'Stats', false),
              _buildNavItem(3, Icons.person_rounded, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isSelected) {
    final color = isSelected ? AppColors.deepCoral : const Color(0xFF94A3B8);
    return InkWell(
      onTap: () {
        if (index == 0) return;
        final routes = ['/', '/calendar', '/analytics', '/profile'];
        Navigator.pushNamed(context, routes[index]);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tasks = context.watch<TaskProvider>();
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Good morning,' : now.hour < 17 ? 'Good afternoon,' : 'Good evening,';

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting, style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateGrey, fontWeight: FontWeight.w500)),
                      Text(auth.user?.name.split(' ').first ?? 'User',
                          style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.slateDark)),
                    ],
                  ),
                  const Spacer(),
                  _HeaderIcon(icon: Icons.search_rounded, onTap: () => Navigator.pushNamed(context, '/search')),
                  const SizedBox(width: 12),
                  _NotificationBell(),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const _AttractiveStreakCard(), // NEW REDESIGN
                  const SizedBox(height: 24),
                  _HeroProgressCard(tasks: tasks),
                  const SizedBox(height: 24),
                  const _QuickActionsGrid(),
                  const SizedBox(height: 32),
                  _SectionHeader(
                    title: "Today's Focus",
                    count: '${tasks.todayTasks.where((t) => t.isCompleted).length}/${tasks.todayTasks.length}',
                    onViewAll: () => Navigator.pushNamed(context, '/task-list'),
                  ),
                ],
              ),
            ),
          ),

          if (tasks.todayTasks.isEmpty)
            const _EmptyState()
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final task = tasks.todayTasks[i];
                    return TaskCard(
                      task: task,
                      onTap: () => Navigator.pushNamed(context, '/task-detail', arguments: task),
                      onToggle: () => context.read<TaskProvider>().toggleTaskComplete(task),
                      onDelete: () => context.read<TaskProvider>().deleteTask(task.id),
                    );
                  },
                  childCount: tasks.todayTasks.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _AttractiveStreakCard extends StatelessWidget {
  const _AttractiveStreakCard();
  @override
  Widget build(BuildContext context) {
    final streak = context.watch<AnalyticsProvider>().currentStreak;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF8936).withOpacity(0.15),
            const Color(0xFFFF5A5F).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFFF8936).withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8936).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(Icons.local_fire_department_rounded, 
                size: 100, color: const Color(0xFFFF8936).withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8936),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8936).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${streak == 0 ? 1 : streak} DAY STREAK',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFF8936),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'You\'re on fire! Keep it up.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slateGrey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFFF8936), size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.slateLight.withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: AppColors.slateDark, size: 24),
      ),
    );
  }
}

class _HeroProgressCard extends StatelessWidget {
  final TaskProvider tasks;
  const _HeroProgressCard({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final progress = tasks.todayProgress;
    final done = tasks.todayTasks.where((t) => t.isCompleted).length;
    final pending = tasks.todayTasks.length - done;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF16E73), Color(0xFFF28B8F)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Progress", 
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('${(progress * 100).toInt()}%', 
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('$done of ${tasks.todayTasks.length} tasks done', 
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _SmallStatChip(label: 'Pending', value: '$pending', icon: Icons.schedule_rounded),
                    const SizedBox(width: 8),
                    _SmallStatChip(label: 'Done', value: '$done', icon: Icons.check_circle_rounded),
                  ],
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ProgressRing(progress: progress, size: 100, color: Colors.white, label: '', strokeWidth: 10),
              Text('${(progress * 100).toInt()}%', 
                style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _SmallStatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text('$value $label', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionTile(icon: Icons.timer_rounded, label: 'Focus', color: AppColors.deepCoral, route: '/pomodoro'),
        _ActionTile(icon: Icons.folder_rounded, label: 'Projects', color: AppColors.purple, route: '/projects'),
        _ActionTile(icon: Icons.book_rounded, label: 'Journal', color: AppColors.teal, route: '/journal'),
        _ActionTile(icon: Icons.flag_rounded, label: 'Goals', color: AppColors.warning, route: '/goals'),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.route});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String count;
  final VoidCallback onViewAll;
  const _SectionHeader({required this.title, required this.count, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.slateDark)),
        TextButton(onPressed: onViewAll, child: Text('View All', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.deepCoral))),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch_rounded, size: 64, color: AppColors.slateGrey.withOpacity(0.1)),
            const SizedBox(height: 16),
            Text('Ready for take off?', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.slateGrey)),
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unread = context.watch<NotificationProvider>().unreadCount;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/notifications'),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.slateLight.withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.notifications_none_rounded, color: AppColors.slateDark, size: 24),
          ),
          if (unread > 0)
            Positioned(
              top: 8, right: 8,
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
            )
        ],
      ),
    );
  }
}
