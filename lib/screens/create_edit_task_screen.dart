import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';

class CreateEditTaskScreen extends StatefulWidget {
  const CreateEditTaskScreen({super.key});
  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _subTaskCtrl = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  String _categoryId = 'personal';
  DateTime? _dueDate;
  List<SubTask> _subTasks = [];
  bool _isLoading = false;
  TaskModel? _editingTask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is TaskModel && _editingTask == null) {
      _editingTask = arg;
      _titleCtrl.text = arg.title;
      _descCtrl.text = arg.description;
      _priority = arg.priority;
      _categoryId = arg.categoryId;
      _dueDate = arg.dueDate;
      _subTasks = List.from(arg.subTasks);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _subTaskCtrl.dispose();
    super.dispose();
  }

  void _addSubTask() {
    if (_subTaskCtrl.text.trim().isEmpty) return;
    setState(() {
      _subTasks.add(SubTask(id: _uuid.v4(), title: _subTaskCtrl.text.trim()));
      _subTaskCtrl.clear();
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.deepCoral,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.slateDark,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();

    if (_editingTask != null) {
      final updated = _editingTask!.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        priority: _priority,
        categoryId: _categoryId,
        dueDate: _dueDate,
        subTasks: _subTasks,
      );
      await taskProvider.updateTask(updated);
    } else {
      await taskProvider.createTask(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        userId: auth.user!.uid,
        priority: _priority,
        categoryId: _categoryId,
        dueDate: _dueDate,
        subTasks: _subTasks,
      );
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<TaskProvider>().categories;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _editingTask != null ? 'Edit Task' : 'New Task',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.slateGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepCoral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_isLoading ? 'Saving...' : 'Save',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WHAT IS TO BE DONE?', 
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slateGrey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              CustomTextField(
                label: '',
                hint: 'Task name here...',
                controller: _titleCtrl,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              
              Text('DETAILS & NOTES', 
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slateGrey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              CustomTextField(
                label: '',
                hint: 'Any additional notes...',
                controller: _descCtrl,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PRIORITY', 
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slateGrey, letterSpacing: 1.2)),
                        const SizedBox(height: 12),
                        _buildPriorityPicker(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text('CATEGORY', 
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slateGrey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = _categoryId == cat.id;
                  return ChoiceChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    onSelected: (v) => setState(() => _categoryId = cat.id),
                    selectedColor: AppColors.deepCoral.withOpacity(0.1),
                    backgroundColor: AppColors.slateLight.withOpacity(0.5),
                    checkmarkColor: AppColors.deepCoral,
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? AppColors.deepCoral : AppColors.slateGrey,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              Text('DUE DATE', 
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slateGrey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              _buildDatePicker(),
              
              const SizedBox(height: 32),
              Text('SUB-TASKS', 
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.slateGrey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              _buildSubTaskList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityPicker() {
    return Row(
      children: TaskPriority.values.map((p) {
        final isSelected = _priority == p;
        final color = p == TaskPriority.high ? AppColors.highPriority 
                    : p == TaskPriority.medium ? AppColors.mediumPriority 
                    : AppColors.lowPriority;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priority = p),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? color : AppColors.slateGrey.withOpacity(0.2), width: isSelected ? 2 : 1),
              ),
              child: Text(
                p.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: isSelected ? color : AppColors.slateGrey, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, fontSize: 11),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slateLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: AppColors.deepCoral),
            const SizedBox(width: 12),
            Text(
              _dueDate == null ? 'Set a deadline...' : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: _dueDate == null ? FontWeight.w400 : FontWeight.w700, color: _dueDate == null ? AppColors.slateGrey : AppColors.slateDark),
            ),
            const Spacer(),
            if (_dueDate != null) IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => _dueDate = null))
          ],
        ),
      ),
    );
  }

  Widget _buildSubTaskList() {
    return Column(
      children: [
        ...List.generate(_subTasks.length, (i) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: AppColors.slateLight.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.check_circle_outline, size: 20),
            title: Text(_subTasks[i].title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
            trailing: IconButton(icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.redAccent), onPressed: () => setState(() => _subTasks.removeAt(i))),
          ),
        )),
        const SizedBox(height: 8),
        TextField(
          controller: _subTaskCtrl,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Add a sub-task...',
            prefixIcon: const Icon(Icons.add_rounded, color: AppColors.deepCoral),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: AppColors.slateLight.withOpacity(0.5),
          ),
          onSubmitted: (_) => _addSubTask(),
        ),
      ],
    );
  }
}

extension StringCap on String {
  String capitalize() => isNotEmpty ? this[0].toUpperCase() + substring(1) : this;
}
