import 'package:flutter/material.dart';
import 'package:monekito/app/transactions/form/transaction_form.page.dart';
import 'package:monekito/core/database/app_db.dart';
import 'package:monekito/core/database/services/transaction/transaction_service.dart';
import 'package:monekito/core/models/transaction/transaction.dart';
import 'package:monekito/core/models/transaction/transaction_type.enum.dart';
import 'package:monekito/core/presentation/widgets/confirm_dialog.dart';
import 'package:monekito/core/routes/route_utils.dart';
import 'package:monekito/core/utils/list_tile_action_item.dart';
import 'package:monekito/core/utils/uuid.dart';
import 'package:monekito/core/utils/balance_validator.dart';

import '../../../i18n/generated/translations.g.dart';

class TransactionViewActionService {
  final TransactionService transactionService = TransactionService.instance;

  TransactionViewActionService();

  List<ListTileActionItem> transactionDetailsActions(
    BuildContext context, {
    required MoneyTransaction transaction,
    bool navigateBackOnDelete = false,
  }) {
    final isRecurrent = transaction.recurrentInfo.isRecurrent;

    return [
      ListTileActionItem(
        label: t.ui_actions.edit,
        icon: Icons.edit,
        onClick: () => RouteUtils.pushRoute(
            context,
            TransactionFormPage(
              transactionToEdit: transaction,
              mode: transaction.type,
            )),
      ),
      if (transaction.recurrentInfo.isNoRecurrent)
        ListTileActionItem(
          label: t.transaction.duplicate_short,
          icon: Icons.control_point_duplicate_rounded,
          onClick: () => TransactionViewActionService()
              .cloneTransactionWithAlertAndSnackBar(context,
                  transaction: transaction),
        ),
      ListTileActionItem(
          label: t.ui_actions.delete,
          icon: Icons.delete,
          role: ListTileActionRole.delete,
          onClick: () => TransactionViewActionService()
                  .deleteTransactionWithAlertAndSnackBar(
                context,
                transactionId: transaction.id,
                isRecurrent: isRecurrent,
                navigateBack: navigateBackOnDelete,
              ))
    ];
  }

  deleteTransactionWithAlertAndSnackBar(
    BuildContext context, {
    required String transactionId,
    bool isRecurrent = false,
    required bool navigateBack,
  }) {
    final t = Translations.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    confirmDialog(
      context,
      icon: Icons.delete,
      dialogTitle: !isRecurrent
          ? t.transaction.delete
          : t.recurrent_transactions.details.delete_header,
      contentParagraphs: [
        Text(!isRecurrent
            ? t.transaction.delete_warning_message
            : t.recurrent_transactions.details.delete_message),
      ],
      confirmationText: t.ui_actions.continue_text,
    ).then((isConfirmed) {
      if (isConfirmed != true) return;

      transactionService.deleteTransaction(transactionId).then((value) {
        if (value == 0) {
          scaffold.showSnackBar(
            const SnackBar(content: Text('Error removing the transaction')),
          );

          return;
        }

        if (navigateBack) {
          Navigator.pop(context);
        }

        scaffold.showSnackBar(SnackBar(
          content: Text(t.transaction.delete_success),
        ));
      }).catchError((err) {
        scaffold.showSnackBar(SnackBar(content: Text('$err')));
      });
    });
  }

  cloneTransactionWithAlertAndSnackBar(
    BuildContext context, {
    required MoneyTransaction transaction,
  }) {
    final t = Translations.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    confirmDialog(
      context,
      icon: Icons.control_point_duplicate_rounded,
      dialogTitle: t.transaction.duplicate,
      contentParagraphs: [Text(t.transaction.duplicate_warning_message)],
      confirmationText: t.ui_actions.continue_text,
    ).then((isConfirmed) async {
      if (isConfirmed != true) return;

      // Validate balance for expense transactions and outgoing transfers before cloning
      if (transaction.type == TransactionType.E || transaction.type == TransactionType.T) {
        try {
          // Use the comprehensive balance validator
          final isValid = await BalanceValidator.validateBalanceWithError(
            context: context,
            account: transaction.account,
            transactionAmount: transaction.value.abs(),
            transactionType: transaction.type,
            transactionDate: transaction.date,
          );

          if (!isValid) {
            debugPrint('[TransactionViewActions] INSUFFICIENT BALANCE! Blocking clone operation.');
            return;
          }
          
          debugPrint('[TransactionViewActions] Balance sufficient, proceeding with clone');
        } catch (error) {
          debugPrint('[TransactionViewActions] Error validating balance: $error');
          scaffold.showSnackBar(
            SnackBar(
              content: Text('Error validating balance: $error'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final newTrId = generateUUID();

      try {
        await _duplicateTransaction(transaction, newTrId);

        scaffold.showSnackBar(
          SnackBar(content: Text(t.transaction.duplicate_success)),
        );
      } catch (error) {
        scaffold.showSnackBar(SnackBar(content: Text('$error')));
      }
    });
  }

  Future<void> _duplicateTransaction(
      MoneyTransaction transaction, String newTrId) async {
    final db = AppDB.instance;

    await transactionService
        .insertTransaction(transaction.copyWith(id: newTrId));

    for (final tag in transaction.tags) {
      await db.into(db.transactionTags).insert(
            TransactionTag(transactionID: newTrId, tagID: tag.id),
          );
    }
  }
}
