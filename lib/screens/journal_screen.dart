import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart' ;
import '../models/journal_entry_model.dart' ;
import '../theme/app_theme.dart' ;

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  MoodType _selectedMood = MoodType.okay;

  final _moods = [
    (MoodType.great, '😄', 'Great'),
    (MoodType.good, '🙂', 'Good'),
    (MoodType.okay, '😐', 'Okay'),
    (MoodType.tired, '😴', 'Tired'),
    (MoodType.stressed, '😰', 'Stressed'),
  ];

  void _addEntry() {
    final ctrl = TextEditingController();
    MoodType mood = _selectedMood;
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
              Text('New Journal Entry',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _moods.map((m) {
                  final selected = m.$1 == mood;
                  return GestureDetector(
                    onTap: () => setSheet(() => mood = m.$1),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.deepCoral.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(m.$2,
                              style: TextStyle(
                                  fontSize: selected ? 28 : 22)),
                        ),
                        Text(m.$3,
                            style: GoogleFonts.inter(
                                fontSize: 10, color: AppColors.slateGrey)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                autofocus: true,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: 'How was your focus session?...'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (ctrl.text.trim().isEmpty) return;
                    await ctx.read<FocusProvider>().addJournalEntry(
                        content: ctrl.text.trim(), mood: mood);
                    if (!mounted) return;
                    Navigator.pop(ctx);
                  },
                  child: Text('Save Entry',
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
    final focus = context.watch<FocusProvider>();
    final entries = focus.journalEntries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Journal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.edit_rounded),
      ),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📓', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('No entries yet',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Tap + to write a journal entry',
                      style: GoogleFonts.inter(color: AppColors.slateGrey)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final e = entries[i];
                final moodEmoji = _moods
                    .firstWhere((m) => m.$1 == e.mood)
                    .$2;
                return Dismissible(
                  key: Key(e.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: AppColors.highPriority.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.delete_outline,
                        color: AppColors.highPriority),
                  ),
                  onDismissed: (_) =>
                      context.read<FocusProvider>().deleteJournalEntry(e.id),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(moodEmoji,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              '${e.date.day}/${e.date.month}/${e.date.year}',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.slateGrey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(e.content,
                            style: GoogleFonts.inter(
                                fontSize: 14, height: 1.5)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
