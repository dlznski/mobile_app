// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'expenses_screen.dart';
import 'history_screen.dart';
import 'database_helper.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAndUpdateBudget();
  }

  Future<void> _checkAndUpdateBudget() async {
    double currentBudget = await DatabaseHelper().getCurrentBudget();
    if (currentBudget > 0) {
      setState(() {
        _budgetController.text = currentBudget.toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twój Budżet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Twój budżet'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_budgetController.text.isNotEmpty) {
                  double newBudgetAmount = double.tryParse(_budgetController.text) ?? 0.0;
                  await DatabaseHelper().setBudget(newBudgetAmount);

                  setState(() {
                    _budgetController.text = newBudgetAmount.toStringAsFixed(2);
                  });
                }
              },
              child: const Text('Ustaw Budżet'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExpensesScreen()),
                );
              },
              child: const Text('Dodaj Wydatek'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
              child: const Text('Historia Wydatków'),
            ),
          ],
        ),
      ),
    );
  }
}
