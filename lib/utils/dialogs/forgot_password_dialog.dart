import 'package:beginners_course/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'we have sent a Password Reset to your Email',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
