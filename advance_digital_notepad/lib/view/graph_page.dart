import 'package:advance_digital_notepad/view/categorie_page.dart';
import 'package:advance_digital_notepad/view/custom_drawer.dart';
import 'package:advance_digital_notepad/view/expense_manager.dart';
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
  Map<String, Color> categoryColors = {
    "Food": Colors.red,
    "Fuel": Colors.blue,
    "Medicine": Colors.green,
    "Entertainment": Colors.purple,
    "Shopping": Colors.pink,
  };

  bool isLoading = true;
  double totalExpense = 0.0;
  int selectedMonths = 1; // Default to 1 Month

  @override
  void initState() {
    super.initState();
    fetchUserExpenses();
  }

  /// **🔥 Fetch Expenses Based on Selected Timeframe**
  Future<void> fetchUserExpenses() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DateTime now = DateTime.now();
    DateTime startDate = selectedMonths == 0
        ? DateTime(2000)
        : now.subtract(Duration(days: selectedMonths * 30));

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("expenses")
          .where("date",
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(startDate))
          .get();

      Map<String, double> expenses = {};
      double total = 0.0;

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String category = data['category'];
        double amount = (data['amount'] as num).toDouble();

        expenses[category] = (expenses[category] ?? 0) + amount;
        total += amount;
      }

      setState(() {
        categoryExpenses = expenses;
        totalExpense = total;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching expenses: $e");
      setState(() => isLoading = false);
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
                  // **Time Filter Selection**
                  SizedBox(
                    height: screenHeight * 0.06,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildFilterButton("1M", 1),
                        buildFilterButton("2M", 2),
                        buildFilterButton("3M", 3),
                        buildFilterButton("6M", 6),
                        buildFilterButton("9M", 9),
                        buildFilterButton("12M", 12),
                        buildFilterButton("All", 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // **Pie Chart**
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: Stack(
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
                        Center(
                          child: Column(
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
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // **Category List**
                  Expanded(
                    child: ListView.separated(
                      itemCount: categoryExpenses.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        String category =
                            categoryExpenses.keys.elementAt(index);
                        double amount = categoryExpenses[category]!;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                categoryColors[category] ?? Colors.grey,
                            child: Icon(Icons.category, color: Colors.white),
                          ),
                          title: Text(category,
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          trailing: Text(
                            "₹${amount.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                        );
                      },
                    ),
                  ),

                  // **Total Amount at Bottom**
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        Text(
                          "₹${totalExpense.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// **Timeframe Selection Buttons**
  Widget buildFilterButton(String label, int months) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedMonths = months;
            isLoading = true;
          });
          fetchUserExpenses();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedMonths == months ? Colors.green : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 16, color: isDarkMode ? Colors.black : Colors.white)),
      ),
    );
  }
}
