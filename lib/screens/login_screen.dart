import 'package:flutter/material.dart';
import 'package:track_app/screens/home_screen.dart';
import 'package:track_app/service/auth_service.dart';
import 'package:track_app/ui_feature/top_left_curve.dart';
import 'package:track_app/ui_feature/custom_text_field.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _keyy = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  final auth = AuthService();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme; // store once, use everywhere

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ClipPath(
                clipper: TopLeftCurve(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: scheme.primary,
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
                        color: scheme.onPrimary,
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

                  ElevatedButton(
                    onPressed: 
                    (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    /*
                    
                    
                    isLoading
                        ? null
                        : () async {
                            setState(() => isLoading = true);

                            if (_keyy.currentState?.validate() ?? false) {
                              try {
                                await auth.login(
                                  emailController.text,
                                  passwordController.text,
                                );
                                if (!mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login Failed: $e")),
                                );
                              } finally {
                                if (mounted) setState(() => isLoading = false);
                              }
                            } else {
                              if (mounted) setState(() => isLoading = false);
                            }
                          },
                     */
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.75,
                        48,
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: scheme.onPrimary)
                        : Text("Login"),
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
              style: TextButton.styleFrom(
                foregroundColor: scheme.primary,
              ),
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}