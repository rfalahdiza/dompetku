import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String title;
  final double amount;
  final String time;
  final IconData icon;
  final Color iconColor;
  final TransactionType type;

  const TransactionModel({
    required this.title,
    required this.amount,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.type,
  });
}