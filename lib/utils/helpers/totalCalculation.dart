class SBillSplitCalculator {
  /// -- Split a single bill evenly among participants
  static List<Map<String, dynamic>> splitBill({
    required double totalAmount,
    required String paidBy,
    required List<String> participants,
  }) {
    double splitAmount = double.parse(
      (totalAmount / participants.length).toStringAsFixed(2),
    );
    List<Map<String, dynamic>> balances = [];

    for (var user in participants) {
      if (user != paidBy) {
        balances.add({'from': user, 'to': paidBy, 'amount': splitAmount});
      }
    }
    return balances;
  }

  /// -- Calculate net simplified balances from multiple expenses
  static List<Map<String, dynamic>> calculateNetBalances(
    List<Map<String, dynamic>> expenses,
  ) {
    Map<String, double> net = {};

    for (var exp in expenses) {
      String paidBy = exp['paidBy'];
      List<String> participants = List<String>.from(exp['participants']);
      double amount = exp['amount'];
      double share = double.parse(
        (amount / participants.length).toStringAsFixed(2),
      );

      for (var user in participants) {
        if (user != paidBy) {
          net[user] = (net[user] ?? 0) - share;
          net[paidBy] = (net[paidBy] ?? 0) + share;
        }
      }
    }

    List<Map<String, dynamic>> settlements = [];
    List<String> users = net.keys.toList();

    for (var i = 0; i < users.length; i++) {
      for (var j = 0; j < users.length; j++) {
        if (i != j && net[users[i]]! > 0 && net[users[j]]! < 0) {
          double amount = net[users[i]]!.clamp(0, -net[users[j]]!);
          if (amount > 0) {
            settlements.add({
              'from': users[j],
              'to': users[i],
              'amount': double.parse(amount.toStringAsFixed(2)),
            });
            net[users[i]] = net[users[i]]! - amount;
            net[users[j]] = net[users[j]]! + amount;
          }
        }
      }
    }

    return settlements;
  }
}
