import 'package:flutter/material.dart';
import 'package:monekito/core/database/services/account/account_service.dart';
import 'package:monekito/core/models/account/account.dart';
import 'package:monekito/core/models/transaction/transaction_type.enum.dart';

/// Utility class for validating account balance before transactions that could reduce balance
class BalanceValidator {
  /// Validates if account has sufficient balance for a transaction
  /// Returns true if balance is sufficient, false otherwise
  static Future<bool> validateBalance({
    required Account account,
    required double transactionAmount,
    required TransactionType transactionType,
    DateTime? transactionDate,
  }) async {
    // Only validate expense transactions and outgoing transfers
    if (transactionType != TransactionType.E && transactionType != TransactionType.T) {
      return true; // Income transactions don't reduce balance
    }

    try {
      final accountBalance = await AccountService.instance
          .getAccountMoney(account: account, date: transactionDate)
          .first;

      // For expense transactions, check if balance is sufficient
      if (transactionType == TransactionType.E) {
        return accountBalance >= transactionAmount;
      }

      // For transfer transactions, check if balance is sufficient
      if (transactionType == TransactionType.T) {
        return accountBalance >= transactionAmount;
      }

      return true;
    } catch (error) {
      debugPrint('[BalanceValidator] Error validating balance: $error');
      return false; // If we can't validate, don't allow the transaction
    }
  }

  /// Shows insufficient balance error message
  static void showInsufficientBalanceError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saldo anda kurang'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Validates balance and shows error if insufficient
  /// Returns true if balance is sufficient, false otherwise
  static Future<bool> validateBalanceWithError({
    required BuildContext context,
    required Account account,
    required double transactionAmount,
    required TransactionType transactionType,
    DateTime? transactionDate,
  }) async {
    final isValid = await validateBalance(
      account: account,
      transactionAmount: transactionAmount,
      transactionType: transactionType,
      transactionDate: transactionDate,
    );

    if (!isValid) {
      showInsufficientBalanceError(context);
    }

    return isValid;
  }
}
