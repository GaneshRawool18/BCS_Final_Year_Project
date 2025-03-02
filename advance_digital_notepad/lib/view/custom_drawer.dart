import 'package:advance_digital_notepad/view/Expense/about_us.dart';
import 'package:advance_digital_notepad/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:advance_digital_notepad/view/categorie_page.dart';
import 'package:advance_digital_notepad/view/graph_page.dart';
import 'package:advance_digital_notepad/view/expense_manager.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0;
  Color containerColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E9F7D), Color(0xFF14A17D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 40, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),

                  // Profile Name
                  const Text(
                    "Ganesh Rawool",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Profile Email
                  const Text(
                    "Ganesh18@gmail.com",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(context, "Transaction",
                      Icons.attach_money_outlined, 0, const ExpenseManager()),
                  buildDrawerItem(context, "Graphs", Icons.pie_chart_outline, 1,
                      const GraphPage()),
                  buildDrawerItem(context, "Category", Icons.category_outlined,
                      2, const CategoriePage()),
                  buildDrawerItem(context, "About Us", Icons.info_outline, 3,
                      const AboutUsPage()),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  containerColor = Colors.red;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.020,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, IconData icon,
      int index, Widget? page) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        if (page != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon,
              color: isSelected ? Colors.green[700] : Colors.grey[700]),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.green[800] : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
