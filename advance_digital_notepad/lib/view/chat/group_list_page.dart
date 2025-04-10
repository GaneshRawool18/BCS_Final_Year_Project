// group_list_page.dart
import 'package:advance_digital_notepad/controller/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'group_chat_page.dart';

class GroupListPage extends StatelessWidget {
  const GroupListPage({Key? key}) : super(key: key);

  // Function to create a new group
  void _createGroup(BuildContext context) async {
    TextEditingController groupController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Create New Group", style: GoogleFonts.poppins()),
        content: TextField(
          controller: groupController,
          decoration: InputDecoration(
            hintText: "Enter group name",
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String groupName = groupController.text.trim();
              if (groupName.isNotEmpty) {
                await FirebaseServices.createGroup(groupName);
                Navigator.pop(context);
              }
            },
            child: Text("Create", style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Groups", style: GoogleFonts.poppins()),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices.streamGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child:
                    Text("No groups available", style: GoogleFonts.poppins()));
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.02,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final groupDoc = snapshot.data!.docs[index];
              final data = groupDoc.data() as Map<String, dynamic>;
              DateTime groupCreated =
                  (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
              String formattedDate =
                  "${groupCreated.day}/${groupCreated.month}/${groupCreated.year}";
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      // Navigate to group details page to see members and join times.
                      Navigator.pushNamed(context, '/groupDetails', arguments: {
                        'groupId': groupDoc.id,
                        'groupName': data['groupName'] ?? 'Unnamed Group',
                        'groupCreated': groupCreated,
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(Icons.group, color: Colors.white),
                    ),
                  ),
                  title: Text(data['groupName'] ?? 'Unnamed Group',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text("Created on: $formattedDate",
                      style: GoogleFonts.poppins(fontSize: 12)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupChatPage(
                          groupId: groupDoc.id,
                          groupName: data['groupName'] ?? 'Unnamed Group',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createGroup(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
