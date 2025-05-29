// src/models/transaction_model.dart
class TransactionModel {
  final int? id;
  final int?
  senderUserId; // ID do usuário que enviou (pode ser null para depósitos)
  final String receiverAccountNumber; // Conta de quem recebeu
  final double amount;
  final String timestamp;
  final String? description;
  final String
  type; // Ex: 'TRANSFER_SENT', 'TRANSFER_RECEIVED', 'DEPOSIT', 'WITHDRAWAL'

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
    // Para inserts onde o ID é autoincrement
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
