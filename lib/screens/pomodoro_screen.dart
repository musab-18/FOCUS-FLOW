import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart' ;
import '../providers/task_provider.dart' ;
import '../theme/app_theme.dart' ;
import 'dart:math' as math;

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusProvider>();
    final tasks = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBreak = focus.timerState == TimerState.breakTime;
    final themeColor = isBreak ? AppColors.teal : AppColors.deepCoral;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Mode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/focus-summary'),
            child: Text('Stats',
                style: GoogleFonts.inter(
                    color: AppColors.deepCoral, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Session type label
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isBreak ? '☕ Break Time' : '🎯 Focus Session',
                  style: GoogleFonts.inter(
                      color: themeColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              const SizedBox(height: 40),
              // Timer ring
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(240, 240),
                      painter: _TimerRingPainter(
                          progress: focus.progress, color: themeColor),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          focus.timerDisplay,
                          style: GoogleFonts.inter(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -2),
                        ),
                        Text(
                          '${focus.completedPomodoros} pomodoro${focus.completedPomodoros != 1 ? 's' : ''} done',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.slateGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ControlButton(
                    icon: Icons.refresh_rounded,
                    onTap: focus.resetTimer,
                    color: AppColors.slateGrey,
                    size: 46,
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: focus.isRunning
                        ? focus.pauseTimer
                        : focus.startTimer,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: themeColor.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Icon(
                        focus.isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (isBreak)
                    _ControlButton(
                      icon: Icons.skip_next_rounded,
                      onTap: focus.skipBreak,
                      color: AppColors.slateGrey,
                      size: 46,
                    )
                  else
                    _ControlButton(
                      icon: Icons.settings_rounded,
                      onTap: () => _showSettings(context, focus),
                      color: AppColors.slateGrey,
                      size: 46,
                    ),
                ],
              ),
              const SizedBox(height: 36),
              // Duration settings
              if (!focus.isRunning) ...[
                Row(
                  children: [
                    Expanded(
                      child: _DurationCard(
                        label: 'Focus',
                        minutes: focus.workDurationMinutes,
                        icon: Icons.bolt_rounded,
                        color: AppColors.deepCoral,
                        onMinus: () => focus.workDurationMinutes > 5
                            ? focus.setWorkDuration(
                                focus.workDurationMinutes - 5)
                            : null,
                        onPlus: () => focus.setWorkDuration(
                            focus.workDurationMinutes + 5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DurationCard(
                        label: 'Break',
                        minutes: focus.breakDurationMinutes,
                        icon: Icons.coffee_rounded,
                        color: AppColors.teal,
                        onMinus: () => focus.breakDurationMinutes > 1
                            ? focus.setBreakDuration(
                                focus.breakDurationMinutes - 1)
                            : null,
                        onPlus: () => focus.setBreakDuration(
                            focus.breakDurationMinutes + 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              // Task selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.slateLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.task_alt_rounded, color: AppColors.deepCoral),
                    const SizedBox(width: 12),
                    Expanded(
                      child: focus.currentTaskId != null
                          ? Text(
                              tasks.tasks
                                      .firstWhere(
                                          (t) => t.id == focus.currentTaskId,
                                          orElse: () => tasks.tasks.first)
                                      .title,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600))
                          : Text('No task linked',
                              style: GoogleFonts.inter(
                                  color: AppColors.slateGrey)),
                    ),
                    TextButton(
                      onPressed: () => _selectTask(context, focus, tasks),
                      child: Text('Choose',
                          style: GoogleFonts.inter(
                              color: AppColors.deepCoral,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Quick nav buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/distraction-blocker'),
                      icon: const Icon(Icons.block_rounded, size: 18),
                      label: Text('Blocker',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/ambient-player'),
                      icon: const Icon(Icons.music_note_rounded, size: 18),
                      label: Text('Sounds',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTask(BuildContext context, FocusProvider focus, TaskProvider tasks) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        builder: (ctx, scroll) => ListView.builder(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          itemCount: tasks.pendingTasks.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('Select Task',
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w700)),
              );
            }
            final task = tasks.pendingTasks[i - 1];
            return ListTile(
              title: Text(task.title, style: GoogleFonts.inter()),
              onTap: () {
                focus.selectTask(task.id);
                Navigator.pop(ctx);
              },
              leading: const Icon(Icons.radio_button_unchecked_rounded,
                  color: AppColors.deepCoral),
            );
          },
        ),
      ),
    );
  }

  void _showSettings(BuildContext context, FocusProvider focus) {
    Navigator.pushNamed(context, '/distraction-blocker');
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double size;

  const _ControlButton(
      {required this.icon,
      this.onTap,
      required this.color,
      required this.size});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.slateLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  final String label;
  final int minutes;
  final IconData icon;
  final Color color;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _DurationCard({
    required this.label,
    required this.minutes,
    required this.icon,
    required this.color,
    this.onMinus,
    this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(label,
                  style: GoogleFonts.inter(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onMinus,
                child: Icon(Icons.remove_rounded, color: color, size: 20),
              ),
              Text('$minutes m',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              GestureDetector(
                onTap: onPlus,
                child: Icon(Icons.add_rounded, color: color, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TimerRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const sw = 10.0;

    canvas.drawCircle(center, radius,
        Paint()
          ..color = color.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter o) =>
      o.progress != progress || o.color != color;
}
