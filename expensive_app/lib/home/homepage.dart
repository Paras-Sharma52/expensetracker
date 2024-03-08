import 'dart:ffi';

import 'package:expensive_app/cotroller/expense_cotroller.dart';
import 'package:expensive_app/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final expensecontroller = Get.put(ExpenseCotroller());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  void _addExpense(BuildContext context) {
    final title = titleController.text;
    final amount = int.parse(amountController.text);
    final date = dateController.text;
    final category = categoryController.text;

    expensecontroller.addExpense(Expense(
        id: "0", title: title, amount: amount, date: date, category: category));
    // print(
    //     'ExpenseBloc state after adding expense: ${BlocProvider.of<ExpenseBloc>(context).state}');

    Navigator.pop(context);
  }

  List<Color> colorList = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Expensies"),
      ),
      body: GetBuilder<ExpenseCotroller>(
        builder: (controller) {
          if (controller.expenseList.isEmpty) {
            return Center(
              child: Text("Add Some Expenses"),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: size.height * 0.2,
                  child: PieChart(
                    dataMap: controller.dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Expenses",
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                ),
                Container(
                  child: Text("Total Expenses \$${controller.totalAmount}"),
                ),
                Container(
                  height: size.height * 0.68,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.expenseList.length,
                      itemBuilder: (context, index) {
                        Expense expense = controller.expenseList[index];
                        return ListTile(
                          title: Text(expense.title),
                          subtitle: Text(expense.category),
                        );
                      }),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Add Expense'),
                ),
                body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(labelText: 'Title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field is required";
                              }
                            },
                          ),
                          TextFormField(
                            controller: amountController,
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field is required";
                              }
                            },
                          ),
                          TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(labelText: 'Date'),
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field is required";
                              }
                            },
                          ),
                          GetBuilder<ExpenseCotroller>(builder: (controller) {
                            return ExpansionTile(
                              onExpansionChanged: (exp) {
                                controller.isExpanded.value = exp;
                              },
                              initiallyExpanded: controller.isExpanded.value,
                              title: Text(
                                controller.selectedCategory.value,
                                style: TextStyle(color: Colors.red),
                              ),
                              children: [
                                ListTile(
                                  title: Text('Health'),
                                  onTap: () {
                                    expensecontroller.selectedCategory.value =
                                        'Health';
                                    categoryController.text = "Health";
                                    controller.handleOptionTap();
                                  },
                                ),
                                ListTile(
                                  title: Text('Fitness'),
                                  onTap: () {
                                    expensecontroller.selectedCategory.value =
                                        'Fitness';
                                    categoryController.text = "Fitness";
                                    controller.handleOptionTap();
                                  },
                                ),
                                ListTile(
                                  title: Text('Food'),
                                  onTap: () {
                                    expensecontroller.selectedCategory.value =
                                        'Food';
                                    categoryController.text = "Food";
                                    controller.handleOptionTap();
                                  },
                                ),
                                ListTile(
                                  title: Text('Investment'),
                                  onTap: () {
                                    expensecontroller.selectedCategory.value =
                                        'Investment';
                                    categoryController.text = "Investment";
                                    controller.handleOptionTap();
                                  },
                                ),
                              ],
                            );
                          }),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (categoryController.text.isNotEmpty) {
                                  _addExpense(context);
                                } else {
                                  Get.showSnackbar(GetSnackBar(
                                    title: "Error",
                                    message: 'Please Select Category',
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              }
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
