import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String id;
  final String name;
  final double balance;
  final DateTime createdAt;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.createdAt,
  });

  // Factory para convertir datos de Firestore en un objeto Account
  factory Account.fromFirestore(Map<String, dynamic> data, String id) {
    return Account(
      id: id,
      name: data['name'] as String,
      balance: (data['balance'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Método para convertir un objeto Account a un mapa que Firestore entienda
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'balance': balance,
      'createdAt': createdAt,
    };
  }
}
