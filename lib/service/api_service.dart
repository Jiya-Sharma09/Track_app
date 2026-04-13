import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:track_app/service/token_storage.dart';

class ApiService {
  Future<dynamic>? apiPost(Uri url, Map<String, dynamic> m) async { // for adding to do's in a particular to do list
    try{
    final jwtToken = await TokenStorage().getToken();
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer : $jwtToken",
      },
      body: {jsonEncode(m)},
    );

    // now need to return this response which is in json : 
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data; 
    }else {
      switch(response.statusCode){
        case 400 : 
        case 401 :
        case 500 :
        case 501 :

      }
    }
    }catch(e){
      throw Exception();
    }
  }
}
