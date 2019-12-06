import 'dart:math';

import "package:flutter/material.dart";

void main() => runApp(new MyFirstFlutterApp());

class MyFirstFlutterApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "First Flutter App",
      home:Scaffold(
        appBar: AppBar(title: Text("Login Page")),
        body: Material(
          color: Colors.lightBlue,
          child: Center(
            child: Text(returnRandomInt(),
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }

  String returnRandomInt(){
    var random = Random();
    int num = random.nextInt(100);
    return "Next number is $num";
  }
}


