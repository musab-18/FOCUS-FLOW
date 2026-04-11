import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart' ;
import '../models/task_model.dart' ;
import '../theme/app_theme.dart' ;
import '../widgets/priority_badge.dart' ;

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)?.settings.arguments as TaskModel;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, '/create-task', arguments: task),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.highPriority),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Delete Task',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  content: Text('Are you sure you want to delete this task?',
                      style: GoogleFonts.inter()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete',
                            style: TextStyle(color: AppColors.highPriority))),
                  ],
                ),
              );
              if (ok == true) {
                context.read<TaskProvider>().deleteTask(task.id);
                if (!context.mounted) return;
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PriorityBadge(priority: task.priority),
                const Spacer(),
                if (task.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 14),
                        const SizedBox(width: 4),
                        Text('Completed',
                            style: GoogleFonts.inter(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              task.title,
              style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null),
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                task.description,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.slateGrey,
                    height: 1.6),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            if (task.dueDate != null)
              _InfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Due Date',
                value:
                    '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
              ),
            _InfoRow(
              icon: Icons.label_rounded,
              label: 'Category',
              value: task.categoryId.toUpperCase(),
            ),
            _InfoRow(
              icon: Icons.access_time_rounded,
              label: 'Created',
              value:
                  '${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
            ),
            if (task.subTasks.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Sub-tasks (${task.completedSubTasks}/${task.subTasks.length})',
                  style:
                      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...task.subTasks.map((s) => CheckboxListTile(
                    value: s.isCompleted,
                    onChanged: (_) {},
                    title: Text(s.title,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            decoration: s.isCompleted
                                ? TextDecoration.lineThrough
                                : null)),
                    activeColor: AppColors.deepCoral,
                    contentPadding: EdgeInsets.zero,
                  )),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<TaskProvider>().toggleTaskComplete(task),
                icon: Icon(task.isCompleted
                    ? Icons.refresh_rounded
                    : Icons.check_rounded),
                label: Text(
                    task.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.slateGrey),
          const SizedBox(width: 12),
          Text(label,
              style:
                  GoogleFonts.inter(color: AppColors.slateGrey, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
