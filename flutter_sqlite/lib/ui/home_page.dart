import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/db/notes_database.dart';
import 'package:flutter_sqlite/model/note.dart';
import 'package:flutter_sqlite/ui/edit_note_page.dart';
import 'package:flutter_sqlite/ui/note_details_page.dart';
import 'package:flutter_sqlite/widget/color_code_converter.dart';
import 'package:flutter_sqlite/widget/note_card_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes;
  bool isLoading = false;
  bool showAboutText = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  Widget _infoButton() {
    return IconButton(
      icon: Icon(
        Icons.info_outline_rounded,
        color: HexColor('f2e9e4'),
      ),
      onPressed: () {
        setState(() {
          if (showAboutText) {
            showAboutText = false;
          } else {
            showAboutText = true;
          }
        });
      },
    );
  }

  var _url = 'http://tahmeedslab.blogspot.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('4a4e69'),
      appBar: AppBar(
        backgroundColor: HexColor('22223b'),
        title: Text(
          'NextG Notes',
          style: TextStyle(fontSize: 24, color: HexColor('f2e9e4')),
        ),
        actions: [
          _infoButton()
          /*
          Icon(Icons.search),
          SizedBox(width: 12),*/
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'Empty',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('22223b'),
        child: Icon(Icons.add_rounded, color: HexColor('f2e9e4')),
        onPressed: () async {
          showAboutText = false;
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );

          refreshNotes();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              height: showAboutText ? 68 : 50,
              child: showAboutText
                  ? Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () async {
                          await canLaunch(_url)
                              ? await launch(_url)
                              : throw 'Could not launch $_url';
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\'NextG Notes\' is a child of ',
                                style: TextStyle(color: HexColor('f2e9e4')),
                              ),
                              TextSpan(
                                text: 'Tahmeed\'s Lab',
                                style: TextStyle(
                                    color: HexColor('f2e9e4'),
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
        color: HexColor('22223b'),
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              showAboutText = false;
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
