import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:track_app/service/token_storage.dart';

// auth service handles the whole auth :
// the auth service makes api call and decodes the response
// it handles all the errors related to the response of the API call
// it then calls the saveToken function to save the token.

class AuthService {
  final _Storage = TokenStorage();
  Future<void> login(String email, String password) async {
    final urlForLogin = Uri.parse(""); // TODO : place the API for login!
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
        if ((data["token"] != null) &&
            (data["token"] is String) &&
            (!data["token"].isEmpty)) {
          await _Storage.saveToken(data["token"]);
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
}
