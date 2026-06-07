import 'dart:async';
import 'package:track_app/service/token_storage.dart';
import 'package:track_app/screens/main_screen.dart';
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
    Future.delayed(const Duration(seconds: 4), () async {
      if (!mounted) return;
      final token = await TokenStorage().getToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => token != null ? const MainScreen() : LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 2),
          child: CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage("assets/images/logo.png"),
          ),
        ),
      ),
    );
  }
}
