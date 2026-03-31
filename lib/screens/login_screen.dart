import 'package:flutter/material.dart';
import 'package:track_app/ui_feature/top_left_curve.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: TopLeftCurve(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.25,
              color: Color.fromARGB(194, 239, 135, 87),
              child: Center(child: Text("Login",style: TextStyle(
                fontSize: MediaQuery.of(context).size.height*0.25*0.25,
              ),))),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.25*0.33,
          )
        ],
      ),
    );
  }
}
/*
0.25 == 100
0.25 
 */