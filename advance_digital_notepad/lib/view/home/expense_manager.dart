import 'package:advance_digital_notepad/view/expense/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advance_digital_notepad/controller/expense_controller.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExpenseManager extends StatefulWidget {
  const ExpenseManager({super.key});

  @override
  State<ExpenseManager> createState() => _ExpenseManagerState();
}

class _ExpenseManagerState extends State<ExpenseManager> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpenseController _expenseController = ExpenseController();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedCategory = "Food";
  String? editingExpenseId;
  String selectedFilter = "All"; // Default filter value

  List<String> categories = [
    "Food",
    "Fuel",
    "Entertainment",
    "Medicine",
    "Shopping"
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    void _pickDate() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    // Function to show the filter options in a dynamic menu
    void _showFilterOptions(BuildContext context) {
      showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(100.0, 50.0, 10.0,
            0.0), // Position the menu (you can adjust as needed)
        items: [
          const PopupMenuItem<String>(
            value: "1 Month",
            child: Text("1 Month"),
          ),
          const PopupMenuItem<String>(
            value: "All",
            child: Text("All"),
          ),
          const PopupMenuItem<String>(
            value: "Particular Date",
            child: Text("Particular Date"),
          ),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value != null) {
          setState(() {
            selectedFilter = value;
            if (selectedFilter == "Particular Date") {
              _pickDate(); // Open the date picker when "Particular Date" is selected
            }
          });
        }
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Expense Manager",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () async {
              _showFilterOptions(context); // Function to show options
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Expanded(child: _buildTransactionList(isDarkMode)),
          _buildAddTransactionButton(),
        ],
      ),
    );
  }

  Widget _buildTransactionList(bool isDarkMode) {
    return StreamBuilder(
      stream:
          _expenseController.getExpensesStream(selectedFilter, selectedDate),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var expenses = snapshot.data!.docs;

        // 🔹 Apply Filtering Logic
        expenses = expenses.where((expense) {
          DateTime expenseDate =
              DateFormat('yyyy-MM-dd').parse(expense['date']);

          if (selectedFilter == "Particular Date") {
            return expenseDate == selectedDate;
          } else if (selectedFilter == "1 Month") {
            return expenseDate
                .isAfter(DateTime.now().subtract(const Duration(days: 30)));
          }
          return true; // "All" case
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            var expense = expenses[index];

            return Card(
              // 🔹 UI remains the same
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category: ${expense['category']}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black)),
                    Text("Date: ${expense['date']} | Day: ${expense['day']}",
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode ? Colors.white70 : Colors.black87)),
                    Text("Description: ${expense['description']}",
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode ? Colors.white70 : Colors.black87)),
                    Text("Amount: ₹${expense['amount']}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showTransactionBottomSheet(expense: expense)),
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(expense.id)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddTransactionButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton.icon(
        onPressed: () => _showTransactionBottomSheet(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Transaction",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  void _showTransactionBottomSheet({DocumentSnapshot? expense}) {
    if (expense != null) {
      setState(() {
        editingExpenseId = expense.id;
        selectedCategory = expense['category'];
        amountController.text = expense['amount'].toString();
        descriptionController.text = expense['description'];
        selectedDate = DateFormat('yyyy-MM-dd').parse(expense['date']);
      });
    } else {
      setState(() {
        editingExpenseId = null;
        selectedCategory = "Food";
        amountController.clear();
        descriptionController.clear();
        selectedDate = DateTime.now();
      });
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 15,
              right: 15,
              top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Date: ${DateFormat.yMMMd().format(selectedDate)}"),
                subtitle:
                    Text("Day: ${DateFormat('EEEE').format(selectedDate)}"),
                trailing: const Icon(Icons.calendar_today, color: Colors.green),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value!),
                items: categories.map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
                }).toList(),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount")),
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description")),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (editingExpenseId == null) {
                      _expenseController.addExpense(
                          selectedCategory,
                          selectedDate,
                          amountController.text,
                          descriptionController.text);
                    } else {
                      _expenseController.updateExpense(
                          editingExpenseId!,
                          selectedCategory,
                          selectedDate,
                          amountController.text,
                          descriptionController.text);
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save, color: Colors.green),
                  label: const Text(
                    "Save",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String expenseId) {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this expense?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        _expenseController.deleteExpense(expenseId);
        Get.back();
      },
    );
  }
}
