//Konfigurasi untuk database sqlite nya
import 'dart:async';

import 'package:note_app/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  NoteDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("notes.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    var sql = '''
     CREATE TABLE $tableNotes(
       ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
       ${NoteFields.isImportant} BOOLEAN NOT NULL,
       ${NoteFields.number} INTEGER NOT NULL,
       ${NoteFields.title} TEXT NOT NULL,
       ${NoteFields.description} TEXT NOT NULL,
       ${NoteFields.time} TEXT NOT NULL
     )
   ''';
    await db.execute(sql);
  }

  //CRUD (Creat, Read, Update, Delete)
  Future<List<Note>> getAllnotes() async {
    final db = await instance.database;

    const orderBy = '${NoteFields.time} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

  Future<Note> getNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("id $id note found");
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db
        .delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }
}
