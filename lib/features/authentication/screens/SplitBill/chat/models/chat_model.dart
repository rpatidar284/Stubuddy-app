import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final List<String> participants;
  final DateTime createdAt;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.createdAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data, String docId) {
    return ChatModel(
      chatId: docId,
      participants: List<String>.from(data['participants']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'participants': participants, 'createdAt': createdAt};
  }
}
