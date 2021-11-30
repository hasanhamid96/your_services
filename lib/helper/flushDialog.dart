import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FlushDialog{

  static  void flushDialog(BuildContext context,String title,String content){
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(color: Colors.blue[800],
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0)
      ],
      backgroundGradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.blue]),
      isDismissible: true,
      title: title,
      message: content,
      duration: Duration(seconds: 2),
    )
      ..show(context);
  }
}