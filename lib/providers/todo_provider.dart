import 'package:flutter/material.dart';
import 'package:track_app/model/todo_model.dart';
import 'package:track_app/model/todo_list_model.dart';
import 'package:track_app/service/api_service.dart';

class TodoProvider extends ChangeNotifier {
  final ApiService _service = ApiService();

  // ── Core UI State ────────────────────────────────────────────────────
  DateTime selectedDate = DateTime.now();
  ToDoList? currentList;
  List<Todo> todos = [];
  bool isLoading = false;
  String? errorMessage;

  // ── Week Cache ───────────────────────────────────────────────────────
  Map<String, List<Todo>> weekCache = {};

  // ── Dummy Data Toggle ────────────────────────────────────────────────
  static const bool useDummyData = false;

  final List<Todo> _dummyTodos = [
    Todo(id: '1', title: 'Buy groceries',       isDone: false),
    Todo(id: '2', title: 'Morning workout',      isDone: true),
    Todo(id: '3', title: 'Read 30 pages',        isDone: false),
    Todo(id: '4', title: 'Team standup call',    isDone: true),
    Todo(id: '5', title: 'Fix login screen bug', isDone: false),
  ];

  final Map<String, List<Todo>> _dummyWeekCache = _buildDummyWeekCache();

  // ── Static Helpers ───────────────────────────────────────────────────
  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Map<String, List<Todo>> _buildDummyWeekCache() {
    final now = DateTime.now();
    final patterns = [
      [true, true, false],
      [true, false, false, true],
      [false, false, true],
      [true, true, true, false],
      [false, true],
      [true, false, false],
      [true, true, false, false, true],
    ];

    return {
      for (int i = 0; i < 7; i++)
        _dateKey(now.subtract(Duration(days: i))): patterns[i]
            .asMap()
            .entries
            .map((e) => Todo(
                  id: '${_dateKey(now.subtract(Duration(days: i)))}-${e.key}',
                  title: 'Task',
                  isDone: e.value,
                ))
            .toList(),
    };
  }

  // ── Date Helper ──────────────────────────────────────────────────────
  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  // ─── FETCH ────────────────────────────────────────────────────────────
  Future<void> getToDo(DateTime date) async {
    selectedDate = date;

    if (useDummyData) {
      todos     = List.from(_dummyTodos);
      weekCache = Map.from(_dummyWeekCache);
      weekCache[_dateKey(date)] = List.from(_dummyTodos);
      notifyListeners();
      return;
    }

    isLoading    = true;
    errorMessage = null;
    notifyListeners();

    try {
      final list  = await _service.fetchTodoList(date);
      final tasks = await _service.fetchTodo(list.id);
      currentList = list;
      todos       = tasks;
      weekCache[_dateKey(date)] = tasks;
      _pruneWeekCache();
    } catch (e) {
      errorMessage = 'Could not load todos: $e';
      todos        = [];
      currentList  = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> preloadWeekStats() async {
    if (useDummyData) return;

    final today = DateTime.now();
    for (int i = 1; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      if (weekCache.containsKey(_dateKey(date))) continue;

      try {
        final list  = await _service.fetchTodoList(date);
        final tasks = await _service.fetchTodo(list.id);
        weekCache[_dateKey(date)] = tasks;
      } catch (_) {}
    }
    notifyListeners();
  }

  void _pruneWeekCache() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    weekCache.removeWhere((key, _) => DateTime.parse(key).isBefore(cutoff));
  }

  // ─── ADD ──────────────────────────────────────────────────────────────
  Future<void> addTodo(String title) async {
    if (useDummyData) {
      todos.add(Todo(
        id:     DateTime.now().millisecondsSinceEpoch.toString(),
        title:  title,
        isDone: false,
      ));
      _syncTodayCache();
      notifyListeners();
      return;
    }

    if (currentList == null) {
      errorMessage = 'No list loaded. Please wait and try again.';
      notifyListeners();
      return;
    }

    final temp = Todo(id: 'temp', title: title, isDone: false);
    todos.add(temp);
    notifyListeners();

    final real = await _service.addToDoService(title, currentList!.id);
    if (real == null) {
      todos.remove(temp);
      errorMessage = 'Could not add task.';
    } else {
      todos[todos.indexOf(temp)] = real;
    }
    _syncTodayCache();
    notifyListeners();
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────
  Future<void> updateTodo(Todo task, String newTitle) async {
    final oldTitle = task.title;
    task.title = newTitle;
    _syncTodayCache();
    notifyListeners();

    if (useDummyData) return;

    final success = await _service.updateToDoService(task.id, newTitle);
    if (!success) {
      task.title   = oldTitle;
      errorMessage = 'Could not update task.';
      _syncTodayCache();
      notifyListeners();
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────
  Future<void> deleteTodo(Todo task) async {
    if (useDummyData) {
      todos.remove(task);
      _syncTodayCache();
      notifyListeners();
      return;
    }

    final backup = List<Todo>.from(todos);
    todos.remove(task);
    notifyListeners();

    final success = await _service.deleteToDoService(task);
    if (!success) {
      todos        = backup;
      errorMessage = 'Could not delete task.';
    }
    _syncTodayCache();
    notifyListeners();
  }

  // ─── TOGGLE ───────────────────────────────────────────────────────────
  Future<void> toggleTodo(Todo task) async {
    task.isDone = !task.isDone;
    _syncTodayCache();
    notifyListeners();

    if (useDummyData) return;

    final success = await _service.toggleStatusService(task);
    if (!success) {
      task.isDone  = !task.isDone;
      errorMessage = 'Could not update task.';
      _syncTodayCache();
      notifyListeners();
    }
  }

  // ─── SYNC HELPER ──────────────────────────────────────────────────────
  void _syncTodayCache() {
    weekCache[_dateKey(selectedDate)] = List.from(todos);
  }

  // ─── CLEAR ERROR ──────────────────────────────────────────────────────
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}