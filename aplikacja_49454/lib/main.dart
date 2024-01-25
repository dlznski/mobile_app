import 'package:flutter/material.dart';
import 'budget_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zarządzanie Finansami',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BudgetScreen(),
    );
  }
}
