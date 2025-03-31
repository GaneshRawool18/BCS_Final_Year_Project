import 'package:advance_digital_notepad/view/custom_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, double> categoryExpenses = {};
  Map<String, dynamic> categorizedExpenses = {};
  Map<String, Color> categoryColors = {
    "Food": Colors.red,
    "Fuel": Colors.blue,
    "Medicine": Colors.green,
    "Entertainment": Colors.purple,
    "Shopping": Colors.pink,
  };

  bool isLoading = true;
  double totalExpense = 0.0;
  int selectedMonths = 1;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    fetchUserExpenses();
  }

  Future<void> fetchUserExpenses() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DateTime now = DateTime.now();
    DateTime calculatedStartDate = selectedMonths == 0
        ? DateTime(2000)
        : now.subtract(Duration(days: selectedMonths * 30));

    if (startDate != null && endDate != null) {
      calculatedStartDate = startDate!;
      now = endDate!;
    }

    if (selectedDay != null) {
      calculatedStartDate = selectedDay!;
      now = selectedDay!;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("expenses")
          .where("date",
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(calculatedStartDate))
          .where("date",
              isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(now))
          .get();

      Map<String, double> expenses = {};
      double total = 0.0;
      Map<String, dynamic> categoryMap = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String category = data['category'];
        double amount = (data['amount'] as num).toDouble();

        expenses[category] = (expenses[category] ?? 0) + amount;
        total += amount;

        if (categoryMap.containsKey(category)) {
          categoryMap[category]['amount'] += amount;
        } else {
          categoryMap[category] = {
            'amount': amount,
            'color': categoryColors[category] ?? Colors.grey,
          };
        }
      }

      setState(() {
        categoryExpenses = expenses;
        categorizedExpenses = categoryMap;
        totalExpense = total;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching expenses: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        selectedMonths = -1;
        selectedDay = null;
        isLoading = true;
      });
      fetchUserExpenses();
    }
  }

  Future<void> pickSingleDay() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDay = picked;
        startDate = null;
        endDate = null;
        selectedMonths = -1;
        isLoading = true;
      });
      fetchUserExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Expense Graph"),
        backgroundColor: isDarkMode ? Colors.black : Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: const CustomDrawer(),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.06,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildFilterButton("Pick a Day", -2),
                        buildFilterButton("1M", 1),
                        buildFilterButton("2M", 2),
                        buildFilterButton("3M", 3),
                        buildFilterButton("6M", 6),
                        buildFilterButton("9M", 9),
                        buildFilterButton("12M", 12),
                        buildFilterButton("All", 0),
                        buildFilterButton("Custom", -1),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            centerSpaceRadius: screenWidth * 0.15,
                            sectionsSpace: 4,
                            sections: categoryExpenses.entries.map((entry) {
                              return PieChartSectionData(
                                color: categoryColors[entry.key] ?? Colors.grey,
                                value: entry.value,
                                title: "${entry.value.toStringAsFixed(2)}₹",
                                titleStyle: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                radius: screenWidth * 0.15,
                              );
                            }).toList(),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54),
                            ),
                            Text(
                              "₹${totalExpense.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categorizedExpenses.length,
                      itemBuilder: (context, index) {
                        String category =
                            categorizedExpenses.keys.elementAt(index);
                        var data = categorizedExpenses[category];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: data['color'],
                              child: Icon(Icons.category, color: Colors.white),
                            ),
                            title: Text(category),
                            trailing: Text(
                              "₹${data['amount'].toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: const Text("Total Expenses",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        "₹${totalExpense.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildFilterButton(String label, int months) {
    bool isSelected = false;

    if (months == -1) {
      isSelected = (startDate != null && endDate != null); // Custom Date Range
    } else if (months == -2) {
      isSelected = (selectedDay != null); // Single Day
    } else {
      isSelected = (selectedMonths == months);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (months == -1) {
              pickDateRange();
            } else if (months == -2) {
              pickSingleDay();
            } else {
              selectedMonths = months;
              startDate = null;
              endDate = null;
              selectedDay = null;
              isLoading = true;
              fetchUserExpenses();
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
