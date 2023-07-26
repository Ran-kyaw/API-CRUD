import 'dart:convert';

import 'package:http/http.dart' as http;

/// All todo api call will be here
class TodoService {
  //For delete
  static Future<bool> deleteById(String id) async {
    String url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  // For ReadAll
  static Future<List?> fetchTodos() async {
    String url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  //for Update
  static Future<bool> updateTodo(String id, Map body) async {
    //Edit Url
    String url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 200;
  }

  //for create add
  static Future<bool> addTodo(Map body) async {
    //Edit Url
    String url = "https://api.nstack.in/v1/todos/";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 201;
  }
}
