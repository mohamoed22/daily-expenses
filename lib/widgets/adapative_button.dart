// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

// ignore: use_key_in_widget_constructors
class AdapativeButton extends StatelessWidget {
   final String text1;
   final VoidCallback handler;
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  AdapativeButton(this.handler, this.text1);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child:  Text(
              text1,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : TextButton(
            onPressed: handler,
            child: Text(
              text1,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
