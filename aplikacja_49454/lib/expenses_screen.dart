// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'transaction.dart';
import 'transaction_repository.dart';
import 'database_helper.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TransactionRepository _transactionRepository = TransactionRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Wydatek'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nazwa Wydatku'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Kwota Wydatku'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                  String expenseName = _nameController.text;
                  double expenseAmount = double.tryParse(_amountController.text) ?? 0.0;

                  Transaction transaction = Transaction(name: expenseName, amount: expenseAmount);
                  await _transactionRepository.insertTransaction(transaction);

                  await DatabaseHelper().updateBudget(expenseAmount);

                  _nameController.clear();
                  _amountController.clear();
                }
              },
              child: const Text('Dodaj Wydatek'),
            ),
          ],
        ),
      ),
    );
  }
}
