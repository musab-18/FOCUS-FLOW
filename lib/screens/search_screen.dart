import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart' ;
import '../theme/app_theme.dart' ;
import '../widgets/task_card.dart' ;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>();
    final results = _query.trim().isEmpty ? [] : tasks.searchTasks(_query);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          style: GoogleFonts.inter(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
            hintStyle: GoogleFonts.inter(color: AppColors.slateGrey),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _ctrl.clear();
                setState(() => _query = '');
              },
            )
        ],
      ),
      body: _query.trim().isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_rounded,
                      size: 64,
                      color: AppColors.slateGrey.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Search your tasks',
                      style: GoogleFonts.inter(
                          color: AppColors.slateGrey, fontSize: 15)),
                ],
              ),
            )
          : results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.slateGrey.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text('No results for "$_query"',
                          style: GoogleFonts.inter(
                              color: AppColors.slateGrey, fontSize: 15)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: results.length,
                  itemBuilder: (ctx, i) {
                    final task = results[i];
                    return TaskCard(
                      task: task,
                      onTap: () =>
                          Navigator.pushNamed(ctx, '/task-detail', arguments: task),
                      onToggle: () =>
                          context.read<TaskProvider>().toggleTaskComplete(task),
                      onDelete: () =>
                          context.read<TaskProvider>().deleteTask(task.id),
                    );
                  },
                ),
    );
  }
}
