import 'package:http/http.dart' as http;
import 'package:track_app/service/config.dart';
import 'dart:convert';
import 'package:track_app/service/token_storage.dart';

// auth service handles the whole auth :
// the auth service makes api call and decodes the response
// it handles all the errors related to the response of the API call
// it then calls the saveToken function to save the token.

class AuthService {
  final baseUrl = Config.baseUrl;
  final _Storage = TokenStorage();
  Future<void> login(String email, String password) async {
    final urlForLogin = Uri.parse("$baseUrl/users/login"); // TODO : place the API for login!
    try {
      final response = await http.post(
        // request for login
        urlForLogin,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          // sending json string !
          "email": email,
          "password": password,
        }),
      );

      // now handling responses :
      Map<String, dynamic> data = {}; // TODO : read why not just "dynamic data ;"
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {};
      }
      if (response.statusCode == 200) {
        // now store the JWT !!
        // store in secure storage (rather than shared preferences as it is more secure)
        if ((data["data"] != null) &&
            (data["data"] is String) &&
            (!data["data"].isEmpty)) {
          await _Storage.saveToken(data["data"]);
          print("TOKEN SAVED: ${data["data"]}"); // TODO: remove later!
        } else {
          throw Exception("Token not found. Try Logging in again.");
        }
      } else {
        //final data = jsonDecode(response.body);
        throw Exception(data["message"] ?? "error : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
  final url = Uri.parse("$baseUrl/users/register");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"name": name, "email": email, "password": password}),
  );
  Map<String, dynamic> data = {};
  try { data = jsonDecode(response.body); 
  print("LOGIN RESPONSE: $data"); 
  } catch (_) {}
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(data["message"] ?? "Registration failed: ${response.statusCode}");
  }
}

}
