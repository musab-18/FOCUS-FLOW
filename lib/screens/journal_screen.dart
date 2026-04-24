import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';
import '../models/journal_entry_model.dart';
import '../theme/app_theme.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MoodType _selectedMood = MoodType.okay;

  final _moods = [
    (MoodType.great, '😄', 'Great'),
    (MoodType.good, '🙂', 'Good'),
    (MoodType.okay, '😐', 'Okay'),
    (MoodType.tired, '😴', 'Tired'),
    (MoodType.stressed, '😰', 'Stressed'),
  ];

  final List<String> _prompts = [
    "What was my biggest win today?",
    "What am I grateful for right now?",
    "How did I handle distractions today?",
    "What is my main goal for tomorrow?",
    "How do I feel after my focus session?",
    "What made me smile today?",
  ];

  // BUILT-IN READING CONTENT
  final List<Map<String, String>> _libraryContent = [
    {
      'title': 'The Power of Deep Focus',
      'excerpt': 'Learn why multi-tasking is a myth and how to enter the flow state...',
      'content': 'Deep work is the ability to focus without distraction on a cognitively demanding task. It is a skill that allows you to quickly master complicated information and produce better results in less time. To achieve this, eliminate all notifications, set a clear goal, and commit to at least 25 minutes of uninterrupted work.',
      'icon': '🧠'
    },
    {
      'title': 'Overcoming Procrastination',
      'excerpt': 'Stop waiting for the "perfect moment" and start achieving your goals now...',
      'content': 'The secret to getting ahead is getting started. Procrastination often stems from fear or overwhelm. Break your tasks into tiny, manageable steps. Use the "2-minute rule": if it takes less than 2 minutes, do it now. Motivation follows action, not the other way around.',
      'icon': '🚀'
    },
    {
      'title': 'The Importance of Breaks',
      'excerpt': 'Why stepping away from your desk actually makes you more productive...',
      'content': 'Taking short breaks during long tasks helps you maintain a constant level of performance. A study found that the brain gradually stops registering a sight, sound, or feeling if that stimulus remains constant over time. Stepping away for 5 minutes helps you return with fresh eyes and renewed energy.',
      'icon': '☕'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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
              const SizedBox(height: 24),

              Text('Inspiration',
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slateGrey)),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _prompts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(_prompts[index], style: GoogleFonts.inter(fontSize: 12)),
                        backgroundColor: AppColors.purple.withOpacity(0.05),
                        onPressed: () {
                          ctrl.text = _prompts[index] + "\n";
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: ctrl,
                autofocus: true,
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText: 'Start writing...'),
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

  void _showReading(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(item['icon']!, style: const TextStyle(fontSize: 48))),
              const SizedBox(height: 16),
              Text(item['title']!, 
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.slateDark)),
              const SizedBox(height: 16),
              Text(item['content']!, 
                  style: GoogleFonts.inter(fontSize: 16, height: 1.6, color: AppColors.slateDark.withOpacity(0.8))),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.slateLight),
                  child: const Text('Close', style: TextStyle(color: AppColors.slateDark)),
                ),
              ),
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
        title: const Text('Journal \u0026 Guides'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepCoral,
          unselectedLabelColor: AppColors.slateGrey,
          indicatorColor: AppColors.deepCoral,
          tabs: const [
            Tab(text: 'My Journal'),
            Tab(text: 'Library'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.edit_rounded),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: USER JOURNAL
          entries.isEmpty
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

          // TAB 2: BUILT-IN LIBRARY
          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _libraryContent.length,
            itemBuilder: (context, index) {
              final item = _libraryContent[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.slateLight.withOpacity(0.5)),
                ),
                child: InkWell(
                  onTap: () => _showReading(item),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.deepCoral.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(item['icon']!, style: const TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title']!, 
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(item['excerpt']!, 
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGrey)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.slateGrey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
