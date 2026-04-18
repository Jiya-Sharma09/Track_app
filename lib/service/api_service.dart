import 'dart:ffi';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:track_app/model/todo_list_model.dart';
import 'package:track_app/model/todo_model.dart';
import 'package:track_app/model/todo_list_model.dart';
import 'dart:convert';
import 'package:track_app/service/token_storage.dart';

class ApiService {
  // Future<dynamic>? apiPost(Uri url, Map<String, dynamic> m) async {
  //   // for adding to do's in a particular to do list
  //   try {
  //     final jwtToken = await TokenStorage().getToken();
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer : $jwtToken",
  //       },
  //       body: {jsonEncode(m)},
  //     );

  //     // now need to return this response which is in json :
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data;
  //     } else {
  //       switch (response.statusCode) {
  //         case 400:
  //         case 401:
  //         case 500:
  //         case 501:
  //       }
  //     }
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  Future<ToDoList> fetchTodoList(DateTime date) async {
    Uri url = Uri.parse("");
    TokenStorage token = TokenStorage();
    String? tokenForCall = await token.getToken();
    //List ToDoList = [];
    dynamic response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenForCall",
      },
    );

    if (response.statusCode == 200) {
      dynamic decoded = jsonDecode(response.body);

      final toDoList = ToDoList.fromJson(decoded['data'][0]);
      return toDoList;
    } else {
      throw Exception("try again list not found !");
    }
  }

  // now fetching the actual To-Do's or tasks inside the to do list

  Future<List<Todo>> fetchTodo(String id) async {
    Uri url = Uri.parse("");
    TokenStorage token = TokenStorage();
    String? tokenForCall = await token.getToken();
    //List ToDoList = [];
    dynamic response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenForCall",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded['data'] == null) return [];
      final List<Todo> tasks = (decoded['data'] as List)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
      return tasks;
    } else {
      throw Exception("try again list not found !");
    }
  }

  // to add to To-Do list :
  Future<Todo?> addToDoService(Todo task) async {
    final Uri url = Uri.parse("");
    TokenStorage token = TokenStorage();
    try {
      String? tokenForCall = await token.getToken();
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokenForCall",
        },
        body: jsonEncode(task),
      );
      if (response.statusCode == 201) {
        final returnedTask = jsonDecode(response.body);
        if(returnedTask == null){
          return null;
        }
        return Todo.fromJson(returnedTask["data"]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> toggleStatusService(Todo task) async {
    final Uri url = Uri.parse("");
    TokenStorage token = TokenStorage();
    try {
      String? tokenForCall = await token.getToken();
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokenForCall",
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteToDoService(Todo task) async {
    final Uri url = Uri.parse("");
    TokenStorage token = TokenStorage();
    try {
      String? tokenForCall = await token.getToken();
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokenForCall",
        },
      );
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
