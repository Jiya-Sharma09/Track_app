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

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          // top curved header
          Align(
            alignment: Alignment.centerLeft,
            child: ClipPath(
              clipper: TopLeftCurve(),
              child: Container(
                width: width * 0.75,
                height: height * 0.25,
                color: scheme.primary,
                child: Align(
                  alignment: Alignment(-0.6, 0.6),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: height * 0.25 * 0.25 * 0.75,
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: height * 0.1),

          // form
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
                  onPressed: isLoading
                      ? null
                      : () {
                          // TODO: validation + API call
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    minimumSize: Size(width * 0.75, 48),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: scheme.onPrimary)
                      : Text("Sign Up"),
                ),
              ],
            ),
          ),

          SizedBox(height: height * 0.05),

          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: scheme.primary,
            ),
            child: Text("Already have an account? Login"),
          ),
        ],
      ),
    );
  }
}