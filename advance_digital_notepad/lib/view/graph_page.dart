import 'package:advance_digital_notepad/view/categorie_page.dart';
import 'package:advance_digital_notepad/view/custom_drawer.dart';
import 'package:advance_digital_notepad/view/expense_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final List<Map<String, dynamic>> categories = [
    {
      "icon": Icons.restaurant,
      "color": Colors.red,
      "name": "Food",
      "amount": 650.00
    },
    {
      "icon": Icons.local_gas_station,
      "color": Colors.blue,
      "name": "Fuel",
      "amount": 600.00
    },
    {
      "icon": Icons.local_hospital,
      "color": Colors.green,
      "name": "Medicine",
      "amount": 500.00
    },
    {
      "icon": Icons.movie,
      "color": Colors.purple,
      "name": "Entertainment",
      "amount": 475.00
    },
    {
      "icon": Icons.shopping_cart,
      "color": Colors.pink,
      "name": "Shopping",
      "amount": 325.00
    },
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool onPressed = false;

  @override
  Widget build(BuildContext context) {
    double total = categories.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Graphs"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pie Chart
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      centerSpaceRadius: 50,
                      sectionsSpace: 4,
                      sections: categories
                          .map(
                            (category) => PieChartSectionData(
                              color: category['color'],
                              value: category['amount'],
                              title: '${category["amount"]}₹',
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              radius: 50,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          "₹$total",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List of Categories
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category['color'],
                      child: Icon(category['icon'], color: Colors.white),
                    ),
                    title: Text(category['name']),
                    trailing: Text(
                      "₹${category['amount']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            // Total Amount at Bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹$total",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Drawer Widget**
  Widget buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Expense Manager',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Saves all your Transactions',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 20),
            buildDrawerItem('Transaction', "assets/images/tra icon.png",
                () => navigateToPage(const ExpenseManager())),
            buildDrawerItem('Graphs', "assets/images/pie icon.png",
                () => navigateToPage(const GraphPage())),
            buildDrawerItem('Category', "assets/images/cate icon.png",
                () => navigateToPage(const CategoriePage())),
            buildDrawerItem('About us', "assets/images/ab_us.png",
                () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  /// **Drawer Item Widget**
  Widget buildDrawerItem(String title, String asset, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color:
            onPressed ? const Color.fromRGBO(14, 161, 125, 0.15) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(asset),
        title: Text(title),
        onTap: () {
          setState(() {
            onPressed = false;
          });
          onTap();
        },
      ),
    );
  }

  /// **Navigation Helper**
  void navigateToPage(Widget page) {
    setState(() {
      onPressed = false;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
