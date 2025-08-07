// File: lib/features/chat/screens/add_friend_screen.dart

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/chat/pages/one_to_one_chat_interface.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/services/firebase_service.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService.getInstance;
  DocumentSnapshot? _foundUser;
  bool _isLoading = false;
  String _message = 'Search to find a friend.';

  void _searchUser() async {
    final username = _searchController.text.trim();
    final currentUser = _firebaseService.getCurrentUser();

    if (username.isEmpty) {
      setState(() {
        _message = 'Search to find a friend.';
        _foundUser = null;
      });
      return;
    }

    if (currentUser != null) {
      final currentUserSnapshot = await _firebaseService.getUserById(
        currentUser.uid,
      );
      if (currentUserSnapshot != null &&
          currentUserSnapshot.exists &&
          currentUserSnapshot.get('username') == username) {
        setState(() {
          _message = 'You cannot add yourself.';
          _foundUser = null;
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _foundUser = null;
      _message = 'Searching...';
    });

    final result = await _firebaseService.getUserByUsername(username);

    setState(() {
      _isLoading = false;
      if (result != null && result.exists) {
        _foundUser = result;
      } else {
        _message = 'No user found with that username.';
        _foundUser = null;
      }
    });
  }

  void _startChat() async {
    if (_foundUser == null) return;

    final currentUser = _firebaseService.getCurrentUser();
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;
    final friendId = _foundUser!.id;

    final chatId = await _firebaseService.createChat(currentUserId, friendId);

    if (mounted) {
      Get.off(() => OneToOneChatInterface(chatId: chatId, contactId: friendId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend', style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUser,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onFieldSubmitted: (_) => _searchUser(),
            ),
            SizedBox(height: 2.h),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_foundUser != null)
              ListTile(
                leading: CircleAvatar(
                  // Conditional check for profile picture
                  backgroundImage:
                      _foundUser!['profilePicture']?.isNotEmpty ?? false
                          ? NetworkImage(_foundUser!['profilePicture'])
                          : null,
                  child:
                      (_foundUser!['profilePicture']?.isEmpty ?? true)
                          ? const Icon(Icons.person)
                          : null,
                ),
                title: Text(_foundUser!['username']),
                trailing: GFButton(
                  onPressed: _startChat,
                  text: "Start Chat",
                  shape: GFButtonShape.pills,

                  size: GFSize.LARGE,
                  color: SColors.buttonPrimary,
                ),
              )
            else
              Center(child: Text(_message)),
          ],
        ),
      ),
    );
  }
}
