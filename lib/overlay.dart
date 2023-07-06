// import 'package:flutter/foundation.dart';
// import 'package:expense_tracker/expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:vibration/vibration.dart';

final formatter = DateFormat.yMMMMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(ExpenseModel expense) addExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';
  // void saveInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleControl = TextEditingController();
  final _amountControl = TextEditingController();
  dynamic _pickedDate;
  Category _selectedCategory = Category.food;
  DateTime? _dateValue;

  void _datePicker() async {
    final now = DateTime.now();
    final dateValue = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    _dateValue = dateValue;
    setState(() {
      _pickedDate = formatter.format(dateValue as DateTime);
    });
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountControl.text);
    final isInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleControl.text.trim().isEmpty || isInvalid || _pickedDate == null) {
      Vibration.vibrate(duration: 1000);
      showCupertinoDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input!'),
          content: const Text('Please make sure valid details were input.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }

    widget.addExpense(
      ExpenseModel(
        title: _titleControl.text,
        amount: enteredAmount,
        date: _dateValue!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountControl.dispose();
    _titleControl.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final height = MediaQuery.of(context).size.height;

        return SizedBox(
          height: (height / 4) * 3,
          child: SingleChildScrollView(
            //Set this SingleChildScrollView inside a SizedBox widget with height=double.infinity to make modal overlay full screen
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleControl,
                            // onChanged: saveInput,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountControl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '₹ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleControl,
                      // onChanged: saveInput,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_pickedDate == null
                                  ? 'No date selected'
                                  : _pickedDate.toString()),
                              IconButton(
                                onPressed: _datePicker,
                                icon: const Icon(Icons.calendar_month_outlined),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountControl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '₹ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_pickedDate == null
                                  ? 'No date selected'
                                  : _pickedDate.toString()),
                              IconButton(
                                onPressed: _datePicker,
                                icon: const Icon(Icons.calendar_month_outlined),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Vibration.vibrate(duration: 200);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitData,
                          child: const Text('Save'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Vibration.vibrate(duration: 200);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitData,
                          child: const Text('Save'),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
