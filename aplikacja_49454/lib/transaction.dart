class Transaction {
  final int? id;
  final String name;
  final double amount;

  Transaction({this.id, required this.name, required this.amount});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'amount': amount};
  }
}
