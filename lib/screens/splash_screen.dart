import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState() {
    ({super.context});
  }
  double opacity = 0.0;
  bool isAnimated = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IgnorePointer(
          ignoring: isAnimated, // ensures that the widget is not clickable
          // is not needed here but is a good practice and i should follow it in production apps hence adding it
          child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration(seconds: 1),
            child: CircleAvatar(radius: 100, backgroundImage: AssetImage("")),
            onEnd: () {
              setState(() {
                isAnimated = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
