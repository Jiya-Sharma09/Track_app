import 'package:http/http.dart' as http;
import 'package:track_app/model/todo_list_model.dart';
import 'package:track_app/model/todo_model.dart';
import 'dart:convert';
import 'package:track_app/service/token_storage.dart';
import 'config.dart';
import 'package:track_app/model/quote_model.dart';

class ApiService {
  final String baseUrl = Config.baseUrl;

  // ── Auth Headers Helper ──────────────────────────────────────────────
  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage().getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ── Fetch or create list for a given date ────────────────────────────
  Future<ToDoList> fetchTodoList(DateTime date) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final res = await http.get(
      Uri.parse("$baseUrl/lists/date/$dateStr"),
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body)['data'];
      if (data.isNotEmpty) return ToDoList.fromJson(data[0]);
    }

    final createRes = await http.post(
      Uri.parse("$baseUrl/lists"),
      headers: await _headers(),
      body: jsonEncode({"title": "My Tasks", "date": dateStr}),
    );

    if (createRes.statusCode == 200 || createRes.statusCode == 201) {
      return ToDoList.fromJson(jsonDecode(createRes.body)['data']);
    }

    throw Exception("Failed to fetch or create list: ${createRes.statusCode}");
  }

  // ── Fetch tasks for a list ───────────────────────────────────────────
  Future<List<Todo>> fetchTodo(String listId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/tasks/$listId"),
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded['data'] == null) return [];
      return (decoded['data'] as List)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception("Failed to fetch tasks: ${res.statusCode}");
  }

  // ── Add task ─────────────────────────────────────────────────────────
  Future<Todo?> addToDoService(String title, String listId) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/tasks"),
        headers: await _headers(),
        body: jsonEncode({"title": title, "listId": listId}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return Todo.fromJson(jsonDecode(res.body)['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── Update task title ────────────────────────────────────────────────
  Future<bool> updateToDoService(String taskId, String newTitle) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/tasks/$taskId"),
        headers: await _headers(),
        body: jsonEncode({"title": newTitle}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Toggle task ──────────────────────────────────────────────────────
  Future<bool> toggleStatusService(Todo task) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/tasks/${task.id}/toggle"),
        headers: await _headers(),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Delete task ──────────────────────────────────────────────────────
  Future<bool> deleteToDoService(Todo task) async {
    try {
      final res = await http.delete(
        Uri.parse("$baseUrl/tasks/${task.id}"),
        headers: await _headers(),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Fetch quote ──────────────────────────────────────────────────────
  Future<Quote> fetchQuote() async {
    final res = await http.get(Uri.parse('https://zenquotes.io/api/random'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return Quote(content: data[0]['q'], author: data[0]['a']);
    }
    throw Exception('Failed to fetch quote');
  }

}