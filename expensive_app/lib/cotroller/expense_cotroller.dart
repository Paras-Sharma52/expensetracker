import 'package:expensive_app/models/expense_model.dart';
import 'package:get/get.dart';

class ExpenseCotroller extends GetxController {
  RxList<Expense> expenseList = <Expense>[].obs;

  RxInt totalAmount = 0.obs;

  RxString selectedCategory = 'Select Category'.obs;

  RxBool isExpanded = false.obs;

  double hel = 0;
  double fit = 0;
  double fod = 0;
  double Inv = 0;
  Map<String, double> dataMap = {
    "Health": 0,
    "Fitness": 0,
    "Food": 0,
    'Investment': 0,
  };

  void handleOptionTap() {
    isExpanded.value = false;
    update();
  }

  void addExpense(Expense expnce) {
    expenseList.add(expnce);

    totalAmount.value += expnce.amount;
    datachange(expnce);
    update();
  }

  void datachange(Expense expense) {
    dataMap = {
      "Health":
          expense.category == "Health" ? hel += expense.amount.toDouble() : hel,
      "Fitness": expense.category == "Fitness"
          ? fit += expense.amount.toDouble()
          : fit,
      "Food":
          expense.category == "Food" ? fod += expense.amount.toDouble() : fod,
      'Investment': expense.category == "Investment"
          ? Inv += expense.amount.toDouble()
          : Inv,
    };

    update();
  }
}
