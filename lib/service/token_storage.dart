import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();
  Future<void> saveToken(String token) async {
    await _storage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    final tokenreturn = await _storage.read(key: "token");
    if (tokenreturn == null || tokenreturn.isEmpty) {
      return null; // don't add any navigations here
      // this class is only for api service not UI navigation
    } else {
      if (JwtDecoder.isExpired(tokenreturn)) {
        await _storage.delete(key: "token");
        return null;
      } else {
        return tokenreturn;
      }
    }
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: "token");
  }
}
