import 'dart:async';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/note.dart';
import 'package:first_flutter_app/utils/database_helper.dart';
import 'package:first_flutter_app/All_screens/NoteDetail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      UpdateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetailPage(Note('','',2),'Add Note');
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColorByPriority(this.noteList[position].priority),
              child: getIconByPriority(this.noteList[position].priority)
            ),
            title: Text(this.noteList[position].title, style: titleStyle),
            subtitle: Text(
              this.noteList[position].date,
              style: titleStyle,
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: (){
                _deleteNoteFromDatabase(context, this.noteList[position]);
              },
            ),
            onTap: () {
              navigateToDetailPage(this.noteList[position],'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetailPage(Note note,String name) async {
    bool res = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note,name);
    }));
    if (res){
      UpdateListView();
    }
  }

  Color getColorByPriority(int priority) {
    switch (priority) {
      case 1: // 1: high, 2: low
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getIconByPriority(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _deleteNoteFromDatabase(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note deleted successfully');
      UpdateListView();
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    final snackbar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void UpdateListView(){
    final Future<Database> db = databaseHelper.initializeDatabase();
    db.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNotesFromDB();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
