import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:track_app/screens/home_screen.dart';
import 'package:track_app/ui_feature/top_left_curve.dart';
import 'package:track_app/ui_feature/custom_text_field.dart';
import 'sign_up_screen.dart';
import 'package:track_app/ui_feature/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _keyy = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  final storage = FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    final urlForLogin = Uri.parse(""); // API for login
    try {
      final response = await http.post(
        urlForLogin,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({  // sending json string !
            "email": email,
            "password": password,
          }),
        
      );
      // now handling responses :
      if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
        // now store the JWT !! 
        // store in secure storage (rather than shared preferences as it is more secure)
        await storage.write(key: "token", value: data["token"]); 
      } else {
        throw Exception("Error occured, Please try again !");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipPath(
              clipper: TopLeftCurve(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.25,
                color: AppTheme.primaryDark1,
                child: Align(
                  alignment: Alignment(-0.6, 0.6),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.height *
                          0.25 *
                          0.25 *
                          0.75,
                      color: AppTheme.heading,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.25 * 0.5),
          Form(
            key: _keyy,
            child: Column(
              children: [
                // e-mail field :
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextField(
                    hint: "email",
                    isPassword: false,
                    controllerText: emailController,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25 * 0.05,
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextField(
                    hint: "password",
                    isPassword: true,
                    controllerText: passwordController,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25 * 0.15,
                ),
                // Login button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.25 * 0.15),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignUpScreen()),
              );
            },
            child: Text("Don't have an account ? sign up"),
          ),
        ],
      ),
    );
  }
}