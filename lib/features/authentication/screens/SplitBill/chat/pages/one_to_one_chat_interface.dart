import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/services/firebase_service.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/widgets/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';

import '../widgets/expense_bubble_widget.dart';
import '../widgets/expense_context_menu_widget.dart';
import '../widgets/expense_input_widget.dart';
import '../widgets/settlement_request_widget.dart';
import './analytics_dashboard.dart';

class OneToOneChatInterface extends StatefulWidget {
  final String chatId;
  final String contactId;

  const OneToOneChatInterface({
    super.key,
    required this.chatId,
    required this.contactId,
  });

  @override
  State<OneToOneChatInterface> createState() => _OneToOneChatInterfaceState();
}

class _OneToOneChatInterfaceState extends State<OneToOneChatInterface> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseService _firebaseService = FirebaseService.getInstance;

  late final Stream<QuerySnapshot> _expensesStream;

  String _contactName = "Loading...";
  String _contactProfilePic = '';
  bool _isLoading = true;
  bool _showContextMenu = false;
  DocumentSnapshot? _selectedExpense;

  @override
  void initState() {
    super.initState();
    _expensesStream = _firebaseService.getChatExpenses(widget.chatId);
    _initializeChatData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _initializeChatData() async {
    final contactUser = await _firebaseService.getUserById(widget.contactId);
    setState(() {
      _contactName = contactUser?['username'] ?? "Unknown";
      _contactProfilePic = contactUser?['profilePicture'] ?? '';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _addExpense(Map<String, dynamic> expense) {
    final currentUser = _firebaseService.getCurrentUser();
    if (currentUser == null) return;

    final newExpense = {
      ...expense,
      'type': 'expense',
      'paidBy': currentUser.uid,
    };
    _firebaseService.addExpenseToChat(widget.chatId, newExpense);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showExpenseContextMenu(DocumentSnapshot expense) {
    setState(() {
      _selectedExpense = expense;
      _showContextMenu = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _showContextMenu = false;
      _selectedExpense = null;
    });
  }

  void _editExpense() {
    // Implement edit logic here
  }

  // FIX: Make delete method async and add a try/catch for better feedback
  void _deleteExpense() async {
    if (_selectedExpense != null) {
      try {
        await _firebaseService.deleteExpense(
          widget.chatId,
          _selectedExpense!.id,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete expense: $e')),
          );
        }
      } finally {
        _hideContextMenu();
      }
    }
  }

  void _addNote() {
    // Implement add note logic here
  }

  void _showSplitDetails() {
    // Implement show split details here
  }

  double _calculateBalance(List<DocumentSnapshot> expenses) {
    double balance = 0;
    final currentUserId = _firebaseService.getCurrentUser()!.uid;

    if (kDebugMode) {
      print('Recalculating balance with ${expenses.length} expenses.');
    }

    for (var doc in expenses) {
      final expense = doc.data() as Map<String, dynamic>;

      if (expense['type'] == 'expense') {
        if (expense['paidBy'] == currentUserId) {
          balance += (expense['amount'] as num).toDouble();
        } else {
          balance -= (expense['amount'] as num).toDouble();
        }
      } else if (expense['type'] == 'settlement_accepted') {
        balance = 0;
      }
    }

    if (kDebugMode) {
      print('New balance is: $balance');
    }

    return balance;
  }

  void _showSettlementRequestDialog(double currentBalance) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Send Settlement Request'),
            content: Text(
              'Do you want to send a settlement request for ₹${currentBalance.abs().toStringAsFixed(2)}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _sendSettlementRequest(currentBalance);
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  void _sendSettlementRequest(double amount) {
    final currentUser = _firebaseService.getCurrentUser();
    if (currentUser == null) return;

    final requestMessage = {
      'type': 'settlement_request',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
      'amount': amount.abs(),
      'paidBy': currentUser.uid,
    };
    _firebaseService.addExpenseToChat(widget.chatId, requestMessage);
  }

  void _acceptSettlement(String settlementId) {
    _firebaseService.updateSettlementStatus(
      widget.chatId,
      settlementId,
      'accepted',
    );
    _sendSystemMessage('All settled up! 🎉');
  }

  void _declineSettlement(String settlementId) {
    _firebaseService.updateSettlementStatus(
      widget.chatId,
      settlementId,
      'declined',
    );
  }

  void _sendSystemMessage(String text) {
    final currentUser = _firebaseService.getCurrentUser();
    if (currentUser != null) {
      final systemMessage = {
        'type': 'system_message',
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'paidBy': currentUser.uid,
      };
      _firebaseService.addExpenseToChat(widget.chatId, systemMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  _contactProfilePic.isNotEmpty
                      ? NetworkImage(_contactProfilePic)
                      : null,
              child:
                  _contactProfilePic.isEmpty ? const Icon(Icons.person) : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _contactName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Online',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsDashboard(),
                  ),
                ),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Analytics',
          ),
          IconButton(
            onPressed: () {
              _expensesStream.first.then((snapshot) {
                final expenseDocs = snapshot.docs;
                final currentBalance = _calculateBalance(expenseDocs);
                if (currentBalance != 0) {
                  if (kDebugMode) {
                    print(
                      'Showing settlement dialog for balance: $currentBalance',
                    );
                  }
                  _showSettlementRequestDialog(currentBalance);
                } else {
                  if (kDebugMode) {
                    print('Balance is zero, not showing settlement dialog.');
                  }
                }
              });
            },
            icon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Settle Up',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, '/profile-management');
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Text('View Profile'),
                  ),
                ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _expensesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final expenseDocs = snapshot.data?.docs ?? [];
                    final currentBalance = _calculateBalance(expenseDocs);

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                currentBalance == 0
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                        .withValues(alpha: 0.1)
                                    : currentBalance > 0
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                        .withValues(alpha: 0.1)
                                    : colorScheme.error.withValues(alpha: 0.1),
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName:
                                    currentBalance == 0
                                        ? 'check_circle'
                                        : currentBalance > 0
                                        ? 'trending_up'
                                        : 'trending_down',
                                color:
                                    currentBalance == 0
                                        ? AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .secondary
                                        : currentBalance > 0
                                        ? AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .secondary
                                        : colorScheme.error,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                currentBalance == 0
                                    ? 'All settled up!'
                                    : currentBalance > 0
                                    ? 'You are owed ₹${currentBalance.abs().toStringAsFixed(2)}'
                                    : 'You owe ₹${currentBalance.abs().toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color:
                                      currentBalance == 0
                                          ? AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .secondary
                                          : currentBalance > 0
                                          ? AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .secondary
                                          : colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            reverse: true,
                            itemCount: expenseDocs.length,
                            itemBuilder: (context, index) {
                              final expense =
                                  expenseDocs[index].data()
                                      as Map<String, dynamic>;
                              final isCurrentUser =
                                  expense['paidBy'] ==
                                  _firebaseService.getCurrentUser()!.uid;

                              if (expense['type'] == 'settlement_request') {
                                final isIncoming =
                                    expense['paidBy'] !=
                                    _firebaseService.getCurrentUser()!.uid;
                                return SettlementRequestWidget(
                                  settlementRequest: expense,
                                  isIncoming: isIncoming,
                                  onAccept:
                                      () => _acceptSettlement(
                                        expenseDocs[index].id,
                                      ),
                                  onDecline:
                                      () => _declineSettlement(
                                        expenseDocs[index].id,
                                      ),
                                );
                              } else {
                                return ExpenseBubbleWidget(
                                  expense: expense,
                                  isCurrentUser: isCurrentUser,
                                  onLongPress:
                                      () => _showExpenseContextMenu(
                                        expenseDocs[index],
                                      ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ExpenseInputWidget(onExpenseAdded: _addExpense),
            ],
          ),
          if (_showContextMenu && _selectedExpense != null)
            ExpenseContextMenuWidget(
              expense: _selectedExpense!.data() as Map<String, dynamic>,
              onEdit: _editExpense,
              onDelete: _deleteExpense,
              onAddNote: _addNote,
              onSplitDetails: _showSplitDetails,
              onDismiss: _hideContextMenu,
            ),
        ],
      ),
    );
  }
}
