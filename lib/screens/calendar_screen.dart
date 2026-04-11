import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/task_provider.dart' ;
import '../models/task_model.dart' ;
import '../theme/app_theme.dart' ;
import '../widgets/task_card.dart' ;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _format = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTasks = _selectedDay == null
        ? <TaskModel>[]
        : tasks.tasks.where((t) {
            if (t.dueDate == null) return false;
            return isSameDay(t.dueDate!, _selectedDay!);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
            child: Text('Today',
                style: GoogleFonts.inter(
                    color: AppColors.deepCoral, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _format,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onFormatChanged: (f) => setState(() => _format = f),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: AppColors.deepCoral,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.deepCoral.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              todayTextStyle: GoogleFonts.inter(
                  color: AppColors.deepCoral, fontWeight: FontWeight.w700),
              selectedTextStyle: GoogleFonts.inter(
                  color: Colors.white, fontWeight: FontWeight.w700),
              defaultTextStyle: GoogleFonts.inter(),
              weekendTextStyle:
                  GoogleFonts.inter(color: AppColors.highPriority),
              markerDecoration: const BoxDecoration(
                color: AppColors.deepCoral,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700),
              formatButtonTextStyle:
                  GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: AppColors.deepCoral),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            eventLoader: (day) => tasks.tasks
                .where((t) => t.dueDate != null && isSameDay(t.dueDate!, day))
                .toList(),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  _selectedDay != null
                      ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'
                      : 'Tasks',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text('${selectedTasks.length} tasks',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.slateGrey)),
              ],
            ),
          ),
          Expanded(
            child: selectedTasks.isEmpty
                ? Center(
                    child: Text('No tasks on this day',
                        style: GoogleFonts.inter(color: AppColors.slateGrey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: selectedTasks.length,
                    itemBuilder: (ctx, i) {
                      final task = selectedTasks[i];
                      return TaskCard(
                        task: task,
                        onToggle: () =>
                            context.read<TaskProvider>().toggleTaskComplete(task),
                        onDelete: () =>
                            context.read<TaskProvider>().deleteTask(task.id),
                        onTap: () =>
                            Navigator.pushNamed(ctx, '/task-detail', arguments: task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
