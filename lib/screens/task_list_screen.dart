import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart' ;
import '../models/project_model.dart' ;
import '../models/task_model.dart' ;
import '../theme/app_theme.dart' ;
import '../widgets/task_card.dart' ;

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

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
    final taskProvider = context.watch<TaskProvider>();
    final project = ModalRoute.of(context)?.settings.arguments as ProjectModel?;
    final categories = ['All', ...taskProvider.categories.map((c) => c.name)];

    List<TaskModel> getFilteredTasks(bool? completed) {
      List<TaskModel> list;
      if (project != null) {
        list = taskProvider.getTasksByProject(project.id);
      } else {
        list = taskProvider.tasks;
      }
      if (_selectedCategory != 'All') {
        final cat = taskProvider.categories
            .firstWhere((c) => c.name == _selectedCategory,
                orElse: () => taskProvider.categories.first);
        list = list.where((t) => t.categoryId == cat.id).toList();
      }
      if (completed == null) return list;
      return list.where((t) => t.isCompleted == completed).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project?.name ?? 'Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.pushNamed(context, '/create-task'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepCoral,
          indicatorColor: AppColors.deepCoral,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Done'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (project == null) ...[
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (ctx, i) {
                  final cat = categories[i];
                  final selected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.deepCoral
                            : AppColors.deepCoral.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat,
                          style: GoogleFonts.inter(
                              color: selected ? Colors.white : AppColors.deepCoral,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                  );
                },
              ),
            ),
          ],
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TaskListBody(tasks: getFilteredTasks(null)),
                _TaskListBody(tasks: getFilteredTasks(false)),
                _TaskListBody(tasks: getFilteredTasks(true)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListBody extends StatelessWidget {
  final List<TaskModel> tasks;
  const _TaskListBody({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text('No tasks here',
            style: GoogleFonts.inter(color: AppColors.slateGrey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        final task = tasks[i];
        return TaskCard(
          task: task,
          onTap: () =>
              Navigator.pushNamed(ctx, '/task-detail', arguments: task),
          onToggle: () =>
              context.read<TaskProvider>().toggleTaskComplete(task),
          onDelete: () => context.read<TaskProvider>().deleteTask(task.id),
        );
      },
    );
  }
}
