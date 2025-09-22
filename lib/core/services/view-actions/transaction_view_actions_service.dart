import 'dart:io';
import 'package:flutter/material.dart';
import 'package:monekito/app/transactions/form/transaction_form.page.dart';
import 'package:monekito/app/transactions/transaction_details.page.dart';
import 'package:monekito/core/database/app_db.dart';
import 'package:monekito/core/database/services/transaction/transaction_service.dart';
import 'package:monekito/core/models/transaction/transaction.dart';
import 'package:monekito/core/models/transaction/transaction_type.enum.dart';
import 'package:monekito/core/presentation/widgets/confirm_dialog.dart';
import 'package:monekito/core/routes/route_utils.dart';
import 'package:monekito/core/services/image_picker_service.dart';
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
        label: 'Change Image',
        icon: Icons.image,
        onClick: () => _changeTransactionImage(context, transaction),
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

  /// Change the image for a transaction
  Future<void> _changeTransactionImage(
    BuildContext context,
    MoneyTransaction transaction,
  ) async {
    final imagePicker = ImagePickerService();
    final selectedImage = await imagePicker.pickImageFromGallery(context);
    
    if (selectedImage != null) {
      try {
        // Save the image path to the transaction notes field
        // We'll use a special format to store the image path
        final imagePath = selectedImage.path;
        final updatedNotes = 'IMAGE_PATH:$imagePath';
        
        // Update the transaction in the database
        final db = AppDB.instance;
        await db.update(db.transactions).replace(
          TransactionInDB(
            id: transaction.id,
            date: transaction.date,
            accountID: transaction.accountID,
            value: transaction.value,
            title: transaction.title,
            notes: updatedNotes,
            type: transaction.type,
            status: transaction.status,
            categoryID: transaction.categoryID,
            valueInDestiny: transaction.valueInDestiny,
            receivingAccountID: transaction.receivingAccountID,
            isHidden: transaction.isHidden,
            locLatitude: transaction.locLatitude,
            locLongitude: transaction.locLongitude,
            locAddress: transaction.locAddress,
            intervalPeriod: transaction.intervalPeriod,
            intervalEach: transaction.intervalEach,
            endDate: transaction.endDate,
            remainingTransactions: transaction.remainingTransactions,
          ),
        );
        
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Image updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the page to show the updated image
        if (context.mounted) {
          Navigator.of(context).pop();
          // The page will automatically refresh due to StreamBuilder
        }
      } catch (e) {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Error updating image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
