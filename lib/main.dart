import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_app/providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'package:track_app/ui_feature/theme.dart';
import 'package:track_app/providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ],
    child : const MyApp()
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);
    return MaterialApp(
      title: 'Track app',
      theme: materialTheme.light()
      ,
      darkTheme: materialTheme.dark(),
      themeMode: themeProvider.themeMode,
      home: SplashScreen(),
    );
  }
}
