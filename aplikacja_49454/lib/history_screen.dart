// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'transaction.dart';
import 'transaction_repository.dart';
import 'database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  double _currentBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentBudget();
  }

  Future<void> _loadCurrentBudget() async {
    double currentBudget = await _databaseHelper.getCurrentBudget();
    setState(() {
      _currentBudget = currentBudget;
    });
  }

  Future<void> _clearHistoryAndBudget() async {
    await _transactionRepository.clearTransactions();
    await _databaseHelper.clearBudget();
    await _loadCurrentBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia Wydatków'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionRepository.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Brak historii wydatków.');
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var transaction = snapshot.data![index];
                      return ListTile(
                        title: Text(transaction.name),
                        subtitle: Text('Kwota: ${transaction.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _currentBudget < 0
                          ? 'Budżet przekroczono o ${(_currentBudget * -1).toStringAsFixed(2)}'
                          : 'Aktualny budżet: ${_currentBudget.toStringAsFixed(2)}',
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _clearHistoryAndBudget();
                      },
                      child: const Text('Wyczyść Historię Wydatków i Budżet'),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
