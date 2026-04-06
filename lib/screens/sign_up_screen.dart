import 'package:flutter/material.dart';
import 'package:track_app/ui_feature/top_left_curve.dart';
import 'package:track_app/ui_feature/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(253, 247, 222, 210),
      body: Column(
        children: [
          // Top curved header
          Align(
            alignment: Alignment.centerLeft,
            child: ClipPath(
              clipper: TopLeftCurve(),
              child: Container(
                width: width * 0.75,
                height: height * 0.25,
                color: Color.fromARGB(194, 239, 135, 87),
                child: Align(
                  alignment: Alignment(-0.6, 0.6),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: height * 0.25 * 0.25 * 0.75,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: height * 0.1),

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: width * 0.75,
                  child: CustomTextField(
                    hint: "Name",
                    isPassword: false,
                    controllerText: nameController,
                  ),
                ),

                SizedBox(height: height * 0.015),

                SizedBox(
                  width: width * 0.75,
                  child: CustomTextField(
                    hint: "Email",
                    isPassword: false,
                    controllerText: emailController,
                  ),
                ),

                SizedBox(height: height * 0.015),

                SizedBox(
                  width: width * 0.75,
                  child: CustomTextField(
                    hint: "Password",
                    isPassword: true,
                    controllerText: passwordController,
                  ),
                ),

                SizedBox(height: height * 0.04),

                ElevatedButton(
                  onPressed: () {
                    // TODO: validation + API call
                  },
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),

          SizedBox(height: height * 0.05),

          // Navigate back to login
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Already have an account? Login"),
          ),
        ],
      ),
    );
  }
}