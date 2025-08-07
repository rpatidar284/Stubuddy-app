// File: lib/core/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class FirebaseService {
  FirebaseService._();
  static final FirebaseService getInstance = FirebaseService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // User Management
  Future<DocumentSnapshot?> getUserByUsername(String username) async {
    final result =
        await _firestore
            .collection('users')
            .where('username', isEqualTo: username)
            .get();
    if (result.docs.isNotEmpty) {
      // Correctly handle the return type
      return result.docs.first;
    }
    // Return null if no user is found
    return null;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  // Chat Management
  Future<String> createChat(String uid1, String uid2) async {
    final chatId = uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
    await _firestore.collection('chats').doc(chatId).set({
      'participants': [uid1, uid2],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return chatId;
  }

  Stream<QuerySnapshot> getChatsStreamForUser() {
    final currentUser = getCurrentUser();
    if (currentUser == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatExpenses(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addExpenseToChat(
    String chatId,
    Map<String, dynamic> expenseData,
  ) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('expenses')
        .add(expenseData);
  }

  Future<void> deleteExpense(String chatId, String expenseId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  Future<void> saveUserToFirestore(
    String uid,
    String username,
    String email,
  ) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'profilePicture':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    });
  }

  Future<void> updateSettlementStatus(
    String chatId,
    String settlementId,
    String status,
  ) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('expenses')
        .doc(settlementId)
        .update({'status': status});
  }

  Future<List<DocumentSnapshot>> getAllUserExpenses() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) {
      return [];
    }

    final allExpenses = <DocumentSnapshot>[];
    final chatsSnapshot =
        await _firestore
            .collection('chats')
            .where('participants', arrayContains: currentUser.uid)
            .get();

    for (final chatDoc in chatsSnapshot.docs) {
      final expensesSnapshot =
          await chatDoc.reference.collection('expenses').get();
      allExpenses.addAll(expensesSnapshot.docs);
    }

    return allExpenses;
  }
}
