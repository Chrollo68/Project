import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://localhost/cividesk_api";

  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {"username": username, "password": password},
    );
    final data = json.decode(response.body);
    return data["status"] == "success";
  }

  static Future<List<Map<String, dynamic>>> getLabours() async {
    final response = await http.get(Uri.parse("$baseUrl/get_labour.php"));
    final body = json.decode(response.body);
    if (body["status"] == "success") {
      return List<Map<String, dynamic>>.from(body["data"]);
    } else {
      throw Exception("Failed to load");
    }
  }

  static Future<bool> addLabour(
    String name,
    String role,
    String wage,
    String contact,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_labour.php"),
      body: {"name": name, "role": role, "wage": wage, "contact": contact},
    );
    final data = json.decode(response.body);
    return data["status"] == "success";
  }

  static Future<bool> deleteLabour(String id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_labour.php"),
      body: {"id": id},
    );
    final data = json.decode(response.body);
    return data["status"] == "success";
  }
}
