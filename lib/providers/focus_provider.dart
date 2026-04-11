import 'dart:async';
import 'package:flutter/material.dart';
import '../models/focus_session_model.dart' ;
import '../models/journal_entry_model.dart' ;
import '../models/notification_model.dart' ;
import '../services/firestore_service.dart' ;
import 'package:uuid/uuid.dart';
import 'notification_provider.dart' ;

enum TimerState { idle, running, paused, breakTime, completed }

class FocusProvider extends ChangeNotifier {
  final FirestoreService _fs = FirestoreService();
  final _uuid = const Uuid();

  // Timer state
  TimerState _timerState = TimerState.idle;
  int _workDurationMinutes = 25;
  int _breakDurationMinutes = 5;
  int _remainingSeconds = 25 * 60;
  int _completedPomodoros = 0;
  Timer? _timer;
  String? _currentTaskId;
  String? _currentSessionId;
  String? _userId;

  // Journal
  List<JournalEntryModel> _journalEntries = [];
  StreamSubscription? _journalSub;

  // Sessions
  List<FocusSessionModel> _sessions = [];
  StreamSubscription? _sessionSub;

  // Distraction blocker
  bool _isBlockerEnabled = false;

  // Ambient player
  bool _isAmbientPlaying = false;
  String _currentAmbient = 'Rain';

  // Notification integration
  NotificationProvider? _notificationProvider;

  void setNotificationProvider(NotificationProvider np) {
    _notificationProvider = np;
  }

  // Getters
  TimerState get timerState => _timerState;
  int get remainingSeconds => _remainingSeconds;
  int get completedPomodoros => _completedPomodoros;
  bool get isRunning => _timerState == TimerState.running;
  bool get isBlockerEnabled => _isBlockerEnabled;
  bool get isAmbientPlaying => _isAmbientPlaying;
  String get currentAmbient => _currentAmbient;
  List<JournalEntryModel> get journalEntries => _journalEntries;
  List<FocusSessionModel> get sessions => _sessions;
  int get workDurationMinutes => _workDurationMinutes;
  int get breakDurationMinutes => _breakDurationMinutes;
  String? get currentTaskId => _currentTaskId;

  String get timerDisplay {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get progress {
    final total = _timerState == TimerState.breakTime
        ? _breakDurationMinutes * 60
        : _workDurationMinutes * 60;
    return 1 - (_remainingSeconds / total);
  }

  void listenToUser(String userId) {
    _userId = userId;
    _journalSub?.cancel();
    _sessionSub?.cancel();
    _journalSub = _fs.journalStream(userId).listen((entries) {
      _journalEntries = entries;
      notifyListeners();
    });
    _sessionSub = _fs.focusSessionsStream(userId).listen((sessions) {
      _sessions = sessions;
      notifyListeners();
    });
  }

  void stopListening() {
    _journalSub?.cancel();
    _sessionSub?.cancel();
  }

  void setWorkDuration(int minutes) {
    _workDurationMinutes = minutes;
    if (_timerState == TimerState.idle) {
      _remainingSeconds = minutes * 60;
    }
    notifyListeners();
  }

  void setBreakDuration(int minutes) {
    _breakDurationMinutes = minutes;
    notifyListeners();
  }

  void selectTask(String? taskId) {
    _currentTaskId = taskId;
    notifyListeners();
  }

  void startTimer() {
    if (_timerState == TimerState.idle || _timerState == TimerState.paused) {
      _timerState = TimerState.running;
      if (_currentSessionId == null && _userId != null) {
        _currentSessionId = _uuid.v4();
      }
      _tick();
      notifyListeners();
    }
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
  }

  void _onTimerComplete() {
    if (_timerState == TimerState.running) {
      _completedPomodoros++;
      _saveSession();
      _timerState = TimerState.breakTime;
      _remainingSeconds = _breakDurationMinutes * 60;
      _notificationProvider?.add(
        type: NotificationType.focusDone,
        title: 'Focus Session Complete 🎉',
        body: 'Great work! Take a ${_breakDurationMinutes}-min break.',
      );
      notifyListeners();
      _tick();
    } else if (_timerState == TimerState.breakTime) {
      _timerState = TimerState.completed;
      _remainingSeconds = _workDurationMinutes * 60;
      _notificationProvider?.add(
        type: NotificationType.breakDone,
        title: 'Break Over ☕',
        body: 'Ready to focus again? Start your next session!',
      );
      notifyListeners();
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    _timerState = TimerState.paused;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _timerState = TimerState.idle;
    _remainingSeconds = _workDurationMinutes * 60;
    _currentSessionId = null;
    notifyListeners();
  }

  void skipBreak() {
    _timer?.cancel();
    _timerState = TimerState.idle;
    _remainingSeconds = _workDurationMinutes * 60;
    _currentSessionId = null;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    if (_userId == null || _currentSessionId == null) return;
    final session = FocusSessionModel(
      id: _currentSessionId!,
      userId: _userId!,
      taskId: _currentTaskId,
      startTime: DateTime.now().subtract(Duration(minutes: _workDurationMinutes)),
      durationMinutes: _workDurationMinutes,
      completedPomodoros: _completedPomodoros,
      isCompleted: true,
    );
    await _fs.addFocusSession(session);
    _currentSessionId = null;
  }

  Future<void> addJournalEntry({
    required String content,
    MoodType mood = MoodType.okay,
  }) async {
    if (_userId == null) return;
    final entry = JournalEntryModel(
      id: _uuid.v4(),
      userId: _userId!,
      content: content,
      mood: mood,
      date: DateTime.now(),
    );
    await _fs.addJournalEntry(entry);
  }

  Future<void> deleteJournalEntry(String id) async {
    await _fs.deleteJournalEntry(id);
  }

  void toggleBlocker() {
    _isBlockerEnabled = !_isBlockerEnabled;
    notifyListeners();
  }

  void toggleAmbient() {
    _isAmbientPlaying = !_isAmbientPlaying;
    notifyListeners();
  }

  void setAmbient(String name) {
    _currentAmbient = name;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _journalSub?.cancel();
    _sessionSub?.cancel();
    super.dispose();
  }
}
