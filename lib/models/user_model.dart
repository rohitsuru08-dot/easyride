// User model with Firestore serialization
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String phone;
  final String role; // 'passenger', 'conductor', 'admin'
  final String language; // 'en' or 'te'
  final double walletBalance;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.role,
    this.language = 'en',
    this.walletBalance = 0.0,
    required this.createdAt,
  });

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'passenger',
      language: map['language'] ?? 'en',
      walletBalance: (map['walletBalance'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'role': role,
      'language': language,
      'walletBalance': walletBalance,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? userId,
    String? name,
    String? phone,
    String? role,
    String? language,
    double? walletBalance,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      language: language ?? this.language,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, name: $name, phone: $phone, role: $role, walletBalance: $walletBalance)';
  }
}
