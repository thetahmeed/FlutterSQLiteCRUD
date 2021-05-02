import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/db/notes_database.dart';
import 'package:flutter_sqlite/model/note.dart';
import 'package:flutter_sqlite/ui/edit_note_page.dart';
import 'package:flutter_sqlite/ui/home_page.dart';
import 'package:flutter_sqlite/widget/color_code_converter.dart';
import 'package:intl/intl.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key key,
    this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel".toUpperCase()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Delete".toUpperCase(),
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () async {
        await NotesDatabase.instance.deleteNote(widget.noteId);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Think again"),
      content: Text("Are you want to delete this note?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: HexColor('4a4e69'),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: HexColor('f2e9e4'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: HexColor('22223b'),
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: HexColor('f2e9e4'),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: TextStyle(color: HexColor('f2e9e4')),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.description,
                      style: TextStyle(color: HexColor('f2e9e4'), fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      tooltip: 'Edit',
      icon: Icon(
        Icons.edit_rounded,
        color: HexColor('f2e9e4'),
      ),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        tooltip: 'Delete',
        icon: Icon(
          Icons.delete_rounded,
          color: HexColor('f2e9e4'),
        ),
        onPressed: () {
          _showAlertDialog(context);
        },
      );
}
