import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<Map<String, dynamic>> verifyEmail(String email) async {
    var response = await http.post(
      Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/forgotpassword.php"),
      body: {"email": email},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> updatePassword(String email, String newPassword) async {
    var response = await http.post(
      Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/updatepassword.php"),
      body: {"email": email, "new_password": newPassword},
    );
    return json.decode(response.body);
  }
}
