// group_chat_page.dart
import 'package:advance_digital_notepad/controller/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For formatting timestamp

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatPage({Key? key, required this.groupId, required this.groupName}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sends the message and clears the textfield.
  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await FirebaseServices.sendMessageToGroup(
        groupId: widget.groupId,
        message: message,
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  // Ensure scrolling to the bottom for new messages.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  // Builds each message bubble.
  Widget _buildMessageItem(Map<String, dynamic> data) {
    // Check if the message is sent by current user
    bool isMe = data['senderId'] == FirebaseServices.getCurrentUserId();
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    String timeString = DateFormat('h:mm a').format(timestamp.toDate());

    return FutureBuilder(
      future: FirebaseServices.getUserDetails(data['senderId']),
      builder: (context, AsyncSnapshot snapshot) {
        String senderName = "Unknown";
        if (snapshot.hasData && snapshot.data.exists) {
          senderName = (snapshot.data.data() as Map<String, dynamic>)['name'] ?? "Unknown";
        }
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005,
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueAccent : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  senderName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['message'] ?? '',
                  style: GoogleFonts.poppins(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeString,
                  style: GoogleFonts.poppins(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context) so colors adapt to dark/light theme.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
              onPressed: () {
                // Navigate to group details page
                Navigator.pushNamed(context, '/groupDetails', arguments: {
                  'groupId': widget.groupId,
                  'groupName': widget.groupName,
                });
              },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseServices.streamGroupMessages(widget.groupId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildMessageItem(data);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: isDark ? Colors.grey[900] : Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
