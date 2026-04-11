import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart' ;
import '../providers/task_provider.dart' ;
import '../providers/focus_provider.dart' ;
import '../theme/app_theme.dart' ;

class ActivityDashboardScreen extends StatefulWidget {
  const ActivityDashboardScreen({super.key});
  @override
  State<ActivityDashboardScreen> createState() =>
      _ActivityDashboardScreenState();
}

class _ActivityDashboardScreenState extends State<ActivityDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final tasks = context.watch<TaskProvider>();
    final focus = context.watch<FocusProvider>();
    // sync data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      analytics.updateData(tasks.tasks, focus.sessions);
    });

    final weeklyData = analytics.weeklyCompletedTasks;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final orderedDays = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return days[d.weekday - 1];
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepCoral,
          indicatorColor: AppColors.deepCoral,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: 'Activity'),
            Tab(text: 'Score'),
            Tab(text: 'Goals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Activity
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row
                Row(
                  children: [
                    _MiniStat(
                        label: 'Completed',
                        value: '${analytics.totalTasksCompleted}',
                        color: AppColors.success),
                    const SizedBox(width: 12),
                    _MiniStat(
                        label: 'Focus hrs',
                        value: '${(analytics.totalFocusMinutes / 60).toStringAsFixed(1)}',
                        color: AppColors.deepCoral),
                    const SizedBox(width: 12),
                    _MiniStat(
                        label: 'Pomodoros',
                        value: '${analytics.totalPomodoros}',
                        color: AppColors.purple),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Tasks Completed – Last 7 Days',
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(
                        drawHorizontalLine: true,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (_) => FlLine(
                            color: AppColors.slateGrey.withOpacity(0.1),
                            strokeWidth: 1),
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) => Text(
                              orderedDays[v.toInt()],
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.slateGrey),
                            ),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (v, _) => v == v.roundToDouble()
                                ? Text(v.toInt().toString(),
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: AppColors.slateGrey))
                                : const SizedBox(),
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: List.generate(7, (i) {
                        return BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            toY: weeklyData[i],
                            color: AppColors.deepCoral,
                            width: 20,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: (weeklyData.reduce((a, b) => a > b ? a : b) + 1).clamp(2, 10),
                              color: AppColors.deepCoral.withOpacity(0.06),
                            ),
                          ),
                        ]);
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text('By Category',
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                if (analytics.categoryBreakdown.isEmpty)
                  Center(
                    child: Text('No data yet',
                        style:
                            GoogleFonts.inter(color: AppColors.slateGrey)),
                  )
                else
                  ...analytics.categoryBreakdown.entries.map((e) {
                    final total = tasks.tasks.length;
                    final pct = total == 0 ? 0.0 : e.value / total;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 80,
                              child: Text(e.key,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.slateGrey))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor:
                                    AppColors.deepCoral.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.deepCoral),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${e.value.toInt()}',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          // Score
          const ProductivityScoreTab(),
          // Goals
          const GoalTrackingTab(),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.slateGrey)),
          ],
        ),
      ),
    );
  }
}

class ProductivityScoreTab extends StatelessWidget {
  const ProductivityScoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final score = analytics.productivityScore;
    final monthlyData = analytics.monthlyFocusMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.deepCoral, Color(0xFFFF8A8E)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Productivity Score',
                          style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('${score.toInt()}',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.w800)),
                      Text(score >= 80
                          ? 'Excellent! 🔥'
                          : score >= 60
                              ? 'Good progress! 👍'
                              : 'Keep going! 💪',
                          style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13)),
                    ],
                  ),
                ),
                const CircularProgressIndicator(
                  value: 1.0,
                  color: Colors.white30,
                  strokeWidth: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Focus Minutes – Last 30 Days',
              style:
                  GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.slateGrey.withOpacity(0.1),
                      strokeWidth: 1),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt() + 1}',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppColors.slateGrey),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}m',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.slateGrey),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(30,
                        (i) => FlSpot(i.toDouble(), monthlyData[i])),
                    isCurved: true,
                    color: AppColors.deepCoral,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.deepCoral.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoalTrackingTab extends StatelessWidget {
  const GoalTrackingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final tasks = context.watch<TaskProvider>();
    final completed = analytics.totalTasksCompleted;
    final goals = [
      ('Complete 10 Tasks', 10, completed.clamp(0, 10)),
      ('Focus 5 Hours', 300, analytics.totalFocusMinutes.clamp(0, 300)),
      ('7-day Streak', 7, 3),
      ('20 Pomodoros', 20, analytics.totalPomodoros.clamp(0, 20)),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: goals.map((g) {
        final progress = g.$2 == 0 ? 0.0 : g.$3 / g.$2;
        final pct = (progress * 100).toInt();
        final done = g.$3 >= g.$2;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: done
                ? AppColors.success.withOpacity(0.06)
                : AppColors.deepCoral.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: done
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.deepCoral.withOpacity(0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(g.$1,
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (done)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 20)
                  else
                    Text('$pct%',
                        style: GoogleFonts.inter(
                            color: AppColors.deepCoral,
                            fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.toDouble(),
                  backgroundColor: AppColors.deepCoral.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(
                      done ? AppColors.success : AppColors.deepCoral),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),
              Text('${g.$3} / ${g.$2}',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.slateGrey)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
