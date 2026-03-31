import 'dart:async';

import 'package:flutter/material.dart';
import 'package:track_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState() {
    //({super.context});
  }
  double opacity = 0.0;
  bool isAnimated = true;

  @override
  void initState() {
    super.initState();
    // Start animation after first frame (cleaner)
    Future.microtask(() {
      setState(() {
        opacity = 1.0;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 1),
          child: CircleAvatar(radius: 100, backgroundImage: AssetImage("assets/images/logo_temp.jpg")),
        ),
      ),
    );
  }
}
