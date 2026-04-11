import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart' ;
import '../widgets/custom_text_field.dart' ;

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});
  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _msgCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepCoral,
          indicatorColor: AppColors.deepCoral,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'FAQs'), Tab(text: 'Feedback')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_FaqTab(), _feedbackTab()],
      ),
    );
  }

  Widget _feedbackTab() {
    if (_sent) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 72),
            const SizedBox(height: 20),
            Text('Thank you! 🙏',
                style: GoogleFonts.inter(
                    fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Your feedback has been submitted.',
                style:
                    GoogleFonts.inter(color: AppColors.slateGrey)),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('We\'d love to hear from you',
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
                'Help us improve FocusFlow by sharing bugs, ideas, or general feedback.',
                style: GoogleFonts.inter(
                    color: AppColors.slateGrey, fontSize: 14, height: 1.5)),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Your Message',
              hint: 'Tell us what you think...',
              controller: _msgCtrl,
              maxLines: 6,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Message required' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _sent = true);
                  }
                },
                child: Text('Send Feedback',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTab extends StatelessWidget {
  final _faqs = const [
    ('How do I create a task?', 'Tap the + button on the home screen or use Quick Add for rapid task entry.'),
    ('What is the Pomodoro technique?', 'Work for 25 mins, then take a 5-min break. Repeat to maximize focus and prevent burnout.'),
    ('How do I organize tasks by project?', 'Go to Projects, create a project, then assign tasks to it via the Create Task form.'),
    ('Can I set reminders?', 'Yes! When creating a task, you can enable reminders and pick a time.'),
    ('How is my productivity score calculated?', 'Based on task completion rate and total focus time over the past 30 days.'),
    ('Is my data backed up?', 'Yes, all data syncs in real-time to Firebase — secure and accessible on any device.'),
  ];

  const _FaqTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _faqs.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (ctx, i) => ExpansionTile(
        title: Text(_faqs[i].$1,
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w600)),
        iconColor: AppColors.deepCoral,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(_faqs[i].$2,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.slateGrey,
                    height: 1.6)),
          ),
        ],
      ),
    );
  }
}
