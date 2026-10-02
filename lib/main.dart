import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() => runApp(const NGenVoiceStudio());

class NGenVoiceStudio extends StatelessWidget {
  const NGenVoiceStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N - Gen Voice Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF990000),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF990000)),
      ),
      home: const HomeScreen(),
    );
  }
}
