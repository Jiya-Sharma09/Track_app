// lib/providers/todo_provider.dart
import 'package:flutter/material.dart';
import 'package:track_app/model/todo_model.dart';
import 'package:track_app/model/todo_list_model.dart';
import 'package:track_app/service/api_service.dart';

class TodoProvider extends ChangeNotifier {
  final ApiService _service = ApiService();

  // state
  DateTime selectedDate = DateTime.now();
  ToDoList? currentList;
  List<Todo> todos = [];
  bool isLoading = false;
  String? errorMessage;

  // dummy data toggle
  static const bool useDummyData = true;
  final List<Todo> _dummyTodos = [
    Todo(id: '1', title: 'Buy groceries', isDone: false),
    Todo(id: '2', title: 'Morning workout', isDone: true),
    Todo(id: '3', title: 'Read 30 pages', isDone: false),
    Todo(id: '4', title: 'Team standup call', isDone: true),
    Todo(id: '5', title: 'Fix login screen bug', isDone: false),
  ];

  // ─── FETCH ────────────────────────────────────────────────────────

  Future<void> getToDo(DateTime date) async {
    selectedDate = date;

    if (useDummyData) {
      todos = List.from(_dummyTodos); // fresh copy each time
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final list = await _service.fetchTodoList(date);
      final tasks = await _service.fetchTodo(list.id);
      currentList = list;
      todos = tasks;
    } catch (e) {
      errorMessage = "Could not load todos: $e";
      todos = [];
      currentList = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ─── ADD ──────────────────────────────────────────────────────────

  Future<void> addTodo(String title) async {
    if (useDummyData) {
      todos.add(Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        isDone: false,
      ));
      notifyListeners();
      return;
    }


    // optimistic update
    final temp = Todo(id: "temp", title: title, isDone: false);
    todos.add(temp);
    notifyListeners();

    final real = await _service.addToDoService(title, currentList!.id);
    if (real == null) {
      todos.remove(temp);
      errorMessage = "Could not add task.";
    } else {
      final index = todos.indexOf(temp);
      todos[index] = real;
    }
    notifyListeners();
  }

  // ─── DELETE ───────────────────────────────────────────────────────

  Future<void> deleteTodo(Todo task) async {
    if (useDummyData) {
      todos.remove(task);
      notifyListeners();
      return;
    }

    // optimistic update
    final backup = List<Todo>.from(todos);
    todos.remove(task);
    notifyListeners();

    final success = await _service.deleteToDoService(task);
    if (!success) {
      todos = backup;
      errorMessage = "Could not delete task.";
      notifyListeners();
    }
  }

  // ─── TOGGLE ───────────────────────────────────────────────────────

  Future<void> toggleTodo(Todo task) async {
    // optimistic update 
    task.isDone = !task.isDone;
    notifyListeners();

    if (useDummyData) return; // no API call needed for dummy

    final success = await _service.toggleStatusService(task);
    if (!success) {
      task.isDone = !task.isDone; // roll back
      errorMessage = "Could not update task.";
      notifyListeners();
    }
  }

  // clears error after widget reads it
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}