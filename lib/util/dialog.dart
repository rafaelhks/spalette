
import 'package:flutter/material.dart';

class DialogUtils{

  static AlertDialog alert(BuildContext context, String title, String message){
    return new AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
  }

  static snackBar(BuildContext context, String text, int duration) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: duration)));
  }

  static snackBarWithKey(GlobalKey<ScaffoldState> key, String text, int duration) {
    key.currentState.showSnackBar(
      new SnackBar(
        content: Text(text),
        duration: Duration(seconds: duration),
      ));
  }
}