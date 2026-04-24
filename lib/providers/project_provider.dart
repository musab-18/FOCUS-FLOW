import 'dart:async';
import 'package:flutter/material.dart';
import '../models/project_model.dart' ;
import '../services/firestore_service.dart' ;
import 'package:uuid/uuid.dart';

class ProjectProvider extends ChangeNotifier {
  final FirestoreService _fs = FirestoreService();
  final _uuid = const Uuid();

  List<ProjectModel> _projects = [];
  StreamSubscription? _sub;

  List<ProjectModel> get projects => _projects;

  void listenToUser(String userId) {
    _sub?.cancel();
    _sub = _fs.projectsStream(userId).listen((projects) {
      _projects = projects;
      notifyListeners();
    }, onError: (e) => debugPrint('Project Stream Error: $e'));
  }

  void stopListening() {
    _projects = [];
    _sub?.cancel();
    notifyListeners();
  }

  Future<void> createProject({
    required String name,
    required String userId,
    String colorHex = '#FF5A5F',
    String description = '',
    DateTime? deadline,
  }) async {
    final project = ProjectModel(
      id: _uuid.v4(),
      name: name,
      colorHex: colorHex,
      userId: userId,
      createdAt: DateTime.now(),
      deadline: deadline,
      description: description,
    );
    await _fs.addProject(project);
  }

  Future<void> updateProject(ProjectModel project) async {
    await _fs.updateProject(project);
  }

  Future<void> deleteProject(String id) async {
    await _fs.deleteProject(id);
  }

  Future<void> incrementProjectTask(String projectId, {bool completed = false}) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final updated = project.copyWith(
      totalTasks: project.totalTasks + 1,
      completedTasks: completed ? project.completedTasks + 1 : project.completedTasks,
    );
    await _fs.updateProject(updated);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
