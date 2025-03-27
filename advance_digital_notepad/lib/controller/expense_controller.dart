import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ExpenseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// **🔍 Get the Logged-in User's ID**
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// **✅ Add Expense for a Specific User**
  Future<void> addExpense(
      String category, DateTime date, String amount, String description) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .add({
      'category': category,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'day': DateFormat('EEEE').format(date),
      'amount': double.tryParse(amount) ?? 0.0,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// **✏️ Update Expense (Only for the Current User)**
  Future<void> updateExpense(String expenseId, String category, DateTime date,
      String amount, String description) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .doc(expenseId)
        .update({
      'category': category,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'day': DateFormat('EEEE').format(date),
      'amount': double.tryParse(amount) ?? 0.0,
      'description': description,
    });
  }

  /// **🗑 Delete Expense (Only for the Current User)**
  Future<void> deleteExpense(String expenseId) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .doc(expenseId)
        .delete();
  }

  /// **📌 Get Stream for UI updates (Only for the Logged-in User)**
  Stream<QuerySnapshot> getExpensesStream() {
    String? userId = getCurrentUserId();
    if (userId == null)
      return const Stream.empty(); // If no user logged in, return empty stream

    return _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
