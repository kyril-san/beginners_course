// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

typedef CloseFunction = void Function();

CloseFunction showLoadingDialog(
    {required BuildContext context, required String text}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10.0,
          ),
          Text(text)
        ],
      ),
    ),
    barrierDismissible: false,
  );
  return () => Navigator.of(context).pop();
}
