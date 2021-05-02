import 'dart:convert';

import 'package:flutter_sqlite/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  // 2. Global field which is calling the constractor
  static final NotesDatabase instance = NotesDatabase._init();
  // 3. Creating field
  static Database _database;
  // 1. Private constructor
  NotesDatabase._init();

  // 4. Open a connection
  Future<Database> get database async {
    // if not null
    if (_database != null) return _database;

    // if null
    _database = await _initDB('notes.db');
    return _database;
  }

  // 5. if null then we are creating the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,
        filePath); // for a specific path use flutter_path_provider package

    // use upgreat method to UPGREAT and increase the version number
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 5.1 Creating database
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType, 
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.createdTime} $textType
    )
    ''');
  }

  // 7. CREATE
  Future<Note> createNote(Note note) async {
    final db = await instance.database;

    /* In case you want to insert raw data */
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

  // 8. READ (Single)
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('Id: $id not found');
    }
  }

  // 8.1 READ (All)
  Future<List<Note>> readAllNotes() async {
    final orderBy = '${NoteFields.createdTime} ASC';
    final db = await instance.database;
    final all = await db.query(tableNotes, orderBy: orderBy);

    /* In case of custom query */
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    return all.map((json) => Note.fromJson(json)).toList();
  }

  // 9. UPDATE
  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    /* In case of raw update use 'rawupdate' */

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  // 10. Delete
  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  // 6. Closing the database
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
