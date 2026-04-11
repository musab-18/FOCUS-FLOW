import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart' ;
import '../providers/task_provider.dart' ;
import '../providers/auth_provider.dart' ;
import '../theme/app_theme.dart' ;
import '../widgets/project_card.dart' ;

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});
  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  void _showCreateProject() {
    final nameCtrl = TextEditingController();
    String selectedColor = '#FF5A5F';
    final colors = ['#FF5A5F', '#9F7AEA', '#4299E1', '#48BB78', '#ED8936', '#38B2AC', '#ECC94B'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Project',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Project name...'),
                style: GoogleFonts.inter(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Text('Color',
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: colors.map((c) {
                  final hex = c.replaceAll('#', '');
                  final color = Color(int.parse('FF$hex', radix: 16));
                  return GestureDetector(
                    onTap: () =>
                        setSheetState(() => selectedColor = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == c
                            ? Border.all(
                                color: Colors.white, width: 2.5)
                            : null,
                        boxShadow: selectedColor == c
                            ? [
                                BoxShadow(
                                    color: color.withOpacity(0.5),
                                    blurRadius: 8)
                              ]
                            : [],
                      ),
                      child: selectedColor == c
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) return;
                    final auth = ctx.read<AuthProvider>();
                    await ctx.read<ProjectProvider>().createProject(
                          name: nameCtrl.text.trim(),
                          userId: auth.user!.uid,
                          colorHex: selectedColor,
                        );
                    if (!mounted) return;
                    Navigator.pop(ctx);
                  },
                  child: Text('Create Project',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final tasks = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateProject,
        child: const Icon(Icons.add_rounded),
      ),
      body: projects.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_open_rounded,
                      size: 70,
                      color: AppColors.slateGrey.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('No projects yet',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Create your first project',
                      style: GoogleFonts.inter(color: AppColors.slateGrey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemCount: projects.length,
              itemBuilder: (ctx, i) {
                final p = projects[i];
                final count = tasks.getTasksByProject(p.id).length;
                return ProjectCard(
                  project: p,
                  taskCount: count,
                  onTap: () => Navigator.pushNamed(ctx, '/task-list',
                      arguments: p),
                );
              },
            ),
    );
  }
}
