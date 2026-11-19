import 'package:flutter/material.dart';
import 'login_page.dart';

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV David',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF205B78)),
        scaffoldBackgroundColor: const Color(0xFFF4F7F9),
      ),
      home: const LoginPage(),
    );
  }
}
