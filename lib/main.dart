import 'package:flutter/material.dart';
import './All_screens/NoteList.dart';
import './All_screens/NoteDetail.dart';

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