import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final double amount;
  final String description;
  final String category;
  final DateTime timestamp;
  final String paidBy;
  final bool isRead;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.paidBy,
    required this.isRead,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> data, String docId) {
    return ExpenseModel(
      id: docId,
      amount: data['amount'] as double,
      description: data['description'] as String,
      category: data['category'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      paidBy: data['paidBy'] as String,
      isRead: data['isRead'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'description': description,
      'category': category,
      'timestamp': timestamp,
      'paidBy': paidBy,
      'isRead': isRead,
    };
  }
}
