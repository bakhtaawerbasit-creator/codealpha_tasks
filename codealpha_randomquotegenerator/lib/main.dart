import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const RandomQuoteApp());
}

class RandomQuoteApp extends StatelessWidget {
  const RandomQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Daily Quotes',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B50E8),
        ),

        fontFamily: 'Roboto',

        scaffoldBackgroundColor:
            const Color(0xFFF5F6FF),

        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}