import 'package:beginners_course/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context) {
  return showErrorDialog(context, 'You cannot share this empty file');
}
