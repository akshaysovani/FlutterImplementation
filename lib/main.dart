import 'package:flutter/material.dart';
import 'package:first_flutter_app/lib/All_screens/NoteList.dart';

void main(){
  runApp(NoteListApp());
}

class NoteListApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      title: "Note Keeper App",
      home: NoteList(),
    );
  }
}