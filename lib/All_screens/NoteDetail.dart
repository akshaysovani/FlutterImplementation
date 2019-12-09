import 'dart:async';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/note.dart';
import 'package:first_flutter_app/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  String name;
  Note note;

  NoteDetail(this.note, this.name);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.name);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String name;
  Note note;

  NoteDetailState(this.note, this.name);

  var _priorities = ['High', 'Low'];
  var _currentPrioritySelected = '';
  TextEditingController tc = TextEditingController();
  TextEditingController desc = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    tc.text = note.title;
    desc.text = note.description;

    return Scaffold(
        appBar: AppBar(
          title: Text(name),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                goToPreviousPage();
              }),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  style: textStyle,
                  value: convertAndUpdatePriorityFromIntToString(note.priority),
                  onChanged: (valueSelectedByUser){
                    setState(() {
                      convertAndUpdatePriorityFromStringToInt(valueSelectedByUser);
                    });
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: tc,
                  style: textStyle,
                  //onChanged: ,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onChanged: (value){
                    updateTitle();
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: desc,
                  style: textStyle,
                  //onChanged: ,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onChanged: (value){
                    updateDescription();
                  }
                ),
              ),



              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {


                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _actiononchanged(String newValue) {
    setState(() {
      this._currentPrioritySelected = newValue;
    });
  }

  void goToPreviousPage() {
    Navigator.pop(context);
  }

  void convertAndUpdatePriorityFromStringToInt(String value){
    switch(value){
      case 'high':
        note.priority = 1;
        break;
      case 'low':
        note.priority = 2;
        break;
    }
  }

  String convertAndUpdatePriorityFromIntToString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _priorities[1]; //high
        break;
      case 2:
        priority = _priorities[2]; //low
        break;
    }
    return priority;
  }

//Update title and description of current node object
  void updateTitle(){
    note.title = tc.text;
  }
  void updateDescription(){
    note.description = desc.text;
  }

//Save data to database
  void _save() async{

    goToPreviousPage();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id == null){ //Save New Note
      result = await databaseHelper.putNote(note);
    }else{ // Update current note
      result = await databaseHelper.updateNote(note);
    }

    if (result != 0){ // success
      _showAlertDialogue('Status','Note saved successfully');
    }else{  // failure
      _showAlertDialogue('Status','Problem while saving Note');
    }
  }

  void _showAlertDialogue(String title,String msg){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }

  void _delete() async{
     if (note.id == null){

     }
  }
}
