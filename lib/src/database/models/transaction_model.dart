
class TransactionModel {
  final int? id;
  final int?
  senderUserId; 
  final String receiverAccountNumber; 
  final double amount;
  final String timestamp;
  final String? description;
  final String
  type; 

  TransactionModel({
    this.id,
    this.senderUserId,
    required this.receiverAccountNumber,
    required this.amount,
    required this.timestamp,
    this.description,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderUserId': senderUserId,
      'receiverAccountNumber': receiverAccountNumber,
      'amount': amount,
      'timestamp': timestamp,
      'description': description,
      'type': type,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    
    return {
      'senderUserId': senderUserId,
      'receiverAccountNumber': receiverAccountNumber,
      'amount': amount,
      'timestamp': timestamp,
      'description': description,
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      senderUserId: map['senderUserId'],
      receiverAccountNumber: map['receiverAccountNumber'],
      amount: map['amount']?.toDouble() ?? 0.0,
      timestamp: map['timestamp'],
      description: map['description'],
      type: map['type'],
    );
  }
}
