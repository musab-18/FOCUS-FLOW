import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/task_provider.dart' ;
import '../providers/auth_provider.dart' ;
import '../models/category_model.dart' ;
import '../theme/app_theme.dart' ;

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});
  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  final _uuid = const Uuid();
  final _colors = [
    '#FF5A5F', '#9F7AEA', '#4299E1', '#48BB78', '#ED8936', '#38B2AC', '#ECC94B',
  ];

  void _showAddCategory() {
    final nameCtrl = TextEditingController();
    String selectedColor = '#FF5A5F';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Category',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Category name...'),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: _colors.map((c) {
                  final hex = c.replaceAll('#', '');
                  final color = Color(int.parse('FF$hex', radix: 16));
                  return GestureDetector(
                    onTap: () => setSheet(() => selectedColor = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == c
                            ? Border.all(color: Colors.white, width: 3)
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) return;
                    final auth = ctx.read<AuthProvider>();
                    final cat = CategoryModel(
                      id: _uuid.v4(),
                      name: nameCtrl.text.trim(),
                      colorHex: selectedColor,
                      userId: auth.user!.uid,
                    );
                    await ctx.read<TaskProvider>().addCategory(cat);
                    if (!mounted) return;
                    Navigator.pop(ctx);
                  },
                  child: Text('Create',
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
    final cats = context.watch<TaskProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Manager'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategory,
        child: const Icon(Icons.add_rounded),
      ),
      body: cats.isEmpty
          ? Center(
              child: Text('No categories yet',
                  style:
                      GoogleFonts.inter(color: AppColors.slateGrey, fontSize: 15)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final cat = cats[i];
                final hex = cat.colorHex.replaceAll('#', '');
                Color catColor;
                try {
                  catColor = Color(int.parse('FF$hex', radix: 16));
                } catch (_) {
                  catColor = AppColors.deepCoral;
                }
                final tasks = ctx.read<TaskProvider>().getTasksByCategory(cat.id);
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: catColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.label_rounded, color: catColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat.name,
                                style: GoogleFonts.inter(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('${tasks.length} tasks',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.slateGrey)),
                          ],
                        ),
                      ),
                      if (cat.userId.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.highPriority, size: 20),
                          onPressed: () =>
                              context.read<TaskProvider>().deleteCategory(cat.id),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
