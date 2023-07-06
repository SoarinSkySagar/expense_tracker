import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/list_custom.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.list,
    required this.removeFunction,
  });
  final List<ExpenseModel> list;
  final void Function(ExpenseModel expense) removeFunction;

  final Widget deleteIcon = const Row(
    children: [
      Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
      SizedBox(
        width: 6,
      ),
      Text(
        'Delete',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => Dismissible(
        onDismissed: (direction) {
          removeFunction(list[index]);
        },
        background: Container(
          color: Theme.of(context).colorScheme.error,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              deleteIcon,
            ],
          ),
        ),
        key: ValueKey(list[index]),
        child: ExpenseItem(list[index]),
      ),
    );
  }
}
