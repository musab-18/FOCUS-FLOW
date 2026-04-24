import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';
import '../models/category_model.dart';
import '../models/focus_session_model.dart';
import '../models/journal_entry_model.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  // ─── TASKS ───────────────────────────────────────────────
  Stream<List<TaskModel>> tasksStream(String userId) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => TaskModel.fromMap(d.data())).toList());
  }

  Future<void> addTask(TaskModel task) async {
    await _db.collection('tasks').doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _db.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }

  // ─── PROJECTS ─────────────────────────────────────────────
  Stream<List<ProjectModel>> projectsStream(String userId) {
    return _db
        .collection('projects')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => ProjectModel.fromMap(d.data())).toList());
  }

  Future<void> addProject(ProjectModel project) async {
    await _db.collection('projects').doc(project.id).set(project.toMap());
  }

  Future<void> updateProject(ProjectModel project) async {
    await _db.collection('projects').doc(project.id).update(project.toMap());
  }

  Future<void> deleteProject(String projectId) async {
    await _db.collection('projects').doc(projectId).delete();
  }

  // ─── CATEGORIES ───────────────────────────────────────────
  Stream<List<CategoryModel>> categoriesStream(String userId) {
    return _db
        .collection('categories')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => CategoryModel.fromMap(d.data())).toList());
  }

  Future<void> addCategory(CategoryModel category) async {
    await _db.collection('categories').doc(category.id).set(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.collection('categories').doc(categoryId).delete();
  }

  // ─── FOCUS SESSIONS ───────────────────────────────────────
  Stream<List<FocusSessionModel>> focusSessionsStream(String userId) {
    return _db
        .collection('focus_sessions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => FocusSessionModel.fromMap(d.data())).toList());
  }

  Future<void> addFocusSession(FocusSessionModel session) async {
    await _db.collection('focus_sessions').doc(session.id).set(session.toMap());
  }

  // ─── JOURNAL ENTRIES ──────────────────────────────────────
  Stream<List<JournalEntryModel>> journalStream(String userId) {
    return _db
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => JournalEntryModel.fromMap(d.data())).toList());
  }

  Future<void> addJournalEntry(JournalEntryModel entry) async {
    await _db.collection('journal_entries').doc(entry.id).set(entry.toMap());
  }

  Future<void> deleteJournalEntry(String id) async {
    await _db.collection('journal_entries').doc(id).delete();
  }
}
