import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dompetku/models/dompet.dart';

class WalletState {
  final double balance;
  final List<TransactionModel> transactions;

  const WalletState({
    required this.balance,
    required this.transactions,
  });

  WalletState copyWith({
    double? balance,
    List<TransactionModel>? transactions,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}

class DompetNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    return const WalletState(
      balance: 255000,
      transactions: [
        TransactionModel(
          title: 'Nasi goreng',
          amount: 15000,
          time: '07.30',
          icon: Icons.restaurant,
          iconColor: Colors.orange,
          type: TransactionType.expense,
        ),
        TransactionModel(
          title: 'Ojek ke kampus',
          amount: 12000,
          time: '08.10',
          icon: Icons.two_wheeler,
          iconColor: Colors.blue,
          type: TransactionType.expense,
        ),
        TransactionModel(
          title: 'Print tugas',
          amount: 3000,
          time: '10.45',
          icon: Icons.school,
          iconColor: Colors.purple,
          type: TransactionType.expense,
        ),
        TransactionModel(
          title: 'Es teh',
          amount: 5000,
          time: '12.15',
          icon: Icons.local_cafe,
          iconColor: Colors.amber,
          type: TransactionType.expense,
        ),
      ],
    );
  }

  void addTransaction(TransactionModel transaction) {
    final updatedList = [transaction, ...state.transactions];
    final updatedBalance = transaction.type == TransactionType.income
        ? state.balance + transaction.amount
        : state.balance - transaction.amount;

    state = state.copyWith(
      balance: updatedBalance,
      transactions: updatedList,
    );
  }
}

final dompetProvider = NotifierProvider<DompetNotifier, WalletState>(
  DompetNotifier.new,
);