import 'package:flutter/material.dart';

import 'models/quote.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q-1 Grand Prix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/result': (context) => const ResultScreen(),
        '/history': (context) {
          final history = ModalRoute.of(context)!.settings.arguments as List<Quote>;
          return HistoryScreen(history: history);
        },
      },
    );
  }
}
