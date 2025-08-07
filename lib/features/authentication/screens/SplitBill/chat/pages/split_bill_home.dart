import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/sprimary_header_container.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/chat/pages/add_friend_screen.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/chat/pages/one_to_one_chat_interface.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/chat/widgets/analyticsTotal.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/services/firebase_service.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
// File: lib/features/chat/screens/split_bill_home.dart

class SplitBillHome extends StatefulWidget {
  const SplitBillHome({super.key});

  @override
  State<SplitBillHome> createState() => _SplitBillHomeState();
}

class _SplitBillHomeState extends State<SplitBillHome> {
  final FirebaseService _firebaseService = FirebaseService.getInstance;
  late Stream<QuerySnapshot> _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = _firebaseService.getChatsStreamForUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          SprimaryHeaderContainer(height: 180),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Split Bill',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.apply(color: SColors.white),
                    ),
                  ],
                ),
                Icon(Icons.chat_outlined, color: Colors.white),
              ],
            ),
          ),

          Column(
            children: [
              SizedBox(height: 100),
              AnalyticsDashboardT(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No chats yet. Start a new chat!'),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final chatDoc = snapshot.data!.docs[index];
                        final participants =
                            chatDoc['participants'] as List<dynamic>;
                        final currentUserId =
                            _firebaseService.getCurrentUser()!.uid;
                        final contactId = participants.firstWhere(
                          (id) => id != currentUserId,
                        );

                        return FutureBuilder<DocumentSnapshot>(
                          future: _firebaseService.getUserById(contactId),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(
                                leading: CircleAvatar(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                title: Text('Loading...'),
                                subtitle: Text('Loading chat...'),
                              );
                            }
                            // Corrected Logic: Check for error and non-existent data safely.
                            if (userSnapshot.hasError ||
                                !userSnapshot.hasData ||
                                !userSnapshot.data!.exists) {
                              return const ListTile(
                                leading: CircleAvatar(child: Icon(Icons.error)),
                                title: Text('User not found'),
                                subtitle: Text('Chat is with an unknown user.'),
                              );
                            }

                            final contactData =
                                userSnapshot.data!.data()
                                    as Map<String, dynamic>;
                            final contactName =
                                contactData['username'] ?? 'Unknown User';
                            final profilePic =
                                contactData['profilePicture'] ?? '';

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    profilePic.isNotEmpty
                                        ? NetworkImage(profilePic)
                                        : null,
                                child:
                                    profilePic.isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                              ),
                              title: Text(
                                contactName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text('Tap to open chat...'),
                              onTap: () {
                                Get.to(
                                  () => OneToOneChatInterface(
                                    chatId: chatDoc.id,
                                    contactId: contactId,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddFriendScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
