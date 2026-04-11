import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart' ;
import '../theme/app_theme.dart' ;
import 'priority_badge.dart' ;

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.highPriority.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.highPriority),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isCompleted
                  ? AppColors.success.withOpacity(0.3)
                  : (isDark
                      ? AppColors.darkCard
                      : const Color(0xFFE2E8F0)),
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: AppColors.slateGrey.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted
                        ? AppColors.success
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.success
                          : (isDark
                              ? const Color(0xFF6B7280)
                              : const Color(0xFFCBD5E0)),
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? (isDark ? Colors.white38 : Colors.black38)
                            : (isDark ? Colors.white : AppColors.slateDark),
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.slateGrey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        PriorityBadge(priority: task.priority, compact: true),
                        const SizedBox(width: 8),
                        if (task.dueDate != null) ...[
                          Icon(Icons.schedule, size: 12,
                              color: isDark ? Colors.white38 : AppColors.slateGrey),
                          const SizedBox(width: 3),
                          Text(
                            _formatDate(task.dueDate!),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : AppColors.slateGrey,
                            ),
                          ),
                        ],
                        if (task.subTasks.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${task.completedSubTasks}/${task.subTasks.length}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.deepCoral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (d.year == tomorrow.year && d.month == tomorrow.month && d.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return '${d.day}/${d.month}/${d.year}';
  }
}
