import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart' ;
import '../theme/app_theme.dart' ;
import '../widgets/task_card.dart' ;

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completed = context.watch<TaskProvider>().completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (completed.isNotEmpty)
            TextButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Clear All',
                        style:
                            GoogleFonts.inter(fontWeight: FontWeight.w700)),
                    content: Text(
                        'Remove all ${completed.length} completed tasks?',
                        style: GoogleFonts.inter()),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear All',
                              style: TextStyle(
                                  color: AppColors.highPriority))),
                    ],
                  ),
                );
                if (ok == true) {
                  for (final t in completed) {
                    context.read<TaskProvider>().deleteTask(t.id);
                  }
                }
              },
              child: Text('Clear All',
                  style: GoogleFonts.inter(
                      color: AppColors.highPriority,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: completed.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.task_alt_rounded,
                      size: 70,
                      color: AppColors.success.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('No completed tasks yet',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Complete tasks to see them here',
                      style: GoogleFonts.inter(color: AppColors.slateGrey)),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.success.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events_rounded,
                          color: AppColors.success),
                      const SizedBox(width: 12),
                      Text('${completed.length} tasks completed!',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppColors.success)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: completed.length,
                    itemBuilder: (ctx, i) {
                      final task = completed[i];
                      return TaskCard(
                        task: task,
                        onTap: () => Navigator.pushNamed(ctx, '/task-detail',
                            arguments: task),
                        onToggle: () => context
                            .read<TaskProvider>()
                            .toggleTaskComplete(task),
                        onDelete: () =>
                            context.read<TaskProvider>().deleteTask(task.id),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
