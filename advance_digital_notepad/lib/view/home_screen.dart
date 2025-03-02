import 'package:advance_digital_notepad/view/NotificationPage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03),
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.025,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 220, 222, 222),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications, size: 28),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const NotificationPage();
                }));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.width * 0.02,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  blurStyle: BlurStyle.outer,
                  color: Color.fromARGB(255, 133, 132, 132),
                )
              ],
              gradient: LinearGradient(
                colors: [Color(0xFF0E9F7D), Color(0xFF14A17D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, Ganesh!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Ganesh18@gmail.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.attach_money, "Transactions"),
              _buildActionButton(Icons.pie_chart, "Graphs"),
              _buildActionButton(Icons.category, "Category"),
              _buildActionButton(Icons.info, "About Us"),
            ],
          ),

          const SizedBox(height: 20),

          // Recent Activity Section
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "View All",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Recent Activity List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildRecentActivity("Bought Groceries", "- ₹500", Colors.red),
                _buildRecentActivity(
                    "Salary Credited", "+ ₹50,000", Colors.green),
                _buildRecentActivity(
                    "Netflix Subscription", "- ₹800", Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Quick Action Buttons
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[200],
          child: Icon(icon, size: 28, color: Colors.green[900]),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Widget for Recent Activity Item
  Widget _buildRecentActivity(String title, String amount, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.history, color: color),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Text(
          amount,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
