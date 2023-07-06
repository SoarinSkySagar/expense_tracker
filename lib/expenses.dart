import 'package:expense_tracker/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/expenses_list.dart';
import 'package:expense_tracker/overlay.dart';
import 'package:vibration/vibration.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<ExpenseModel> _registered = [
    //Expense list data goes here
  ];

  void _openOverlay() {
    Vibration.vibrate(duration: 200);
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(addExpense: _addExpense);
      },
    );
  }

  void _addExpense(ExpenseModel expense) {
    setState(() {
      _registered.add(expense);
    });
    Vibration.vibrate(duration: 400);
  }

  void _deleteItem(ExpenseModel expense) async {
    final expenseIndex = _registered.indexOf(expense);
    setState(() {
      _registered.remove(expense);
    });

    Vibration.vibrate(duration: 400);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registered.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text('No expenses found, start by adding some!'),
    );

    if (_registered.isNotEmpty) {
      mainContent = ExpenseList(list: _registered, removeFunction: _deleteItem);
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.green,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < height
          ? Column(
              children: [
                Chart(expenses: _registered),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'EXPENSE LIST (swipe away the items to delete them)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Expanded(
                        child: mainContent,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registered)),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'EXPENSE LIST (swipe away the items to delete them)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Expanded(
                        child: mainContent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
