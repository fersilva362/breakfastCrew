/* import 'dart:async';
import 'dart:developer' as devtools show log;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:user_app/extension/list/filter.dart';
import 'package:user_app/services/auth/auth_exceptions.dart';

import 'crud/crud_exceptions.dart';

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        email = map[emailCol] as String;
  @override
  String toString() {
    return 'ID is $id and email is $email';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynceWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSynceWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idCol] as int,
        userId = map[userIdCol] as int,
        text = map[textCol] as String,
        isSynceWithCloud = (map[isSynceWiothCloudCol] == 1 ? true : false);
  @override
  String toString() {
    return 'Note has ID:$id and userId:$userId with text:$text';
  }

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class NoteService {
  Database? _db;
  DatabaseUser? _user;

  List<DatabaseNote> _notes = [];
  late StreamController<List<DatabaseNote>> _notesStreamController;
  //Singleton
  static final NoteService _shared = NoteService._sharedInstance();
  NoteService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NoteService() => _shared;

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.userId == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadAllNotes();
        }
      });

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      _user = user;
      return user;
    } on UserNotFoundAuthExceptions {
      final createdUser = await createUser(email: email);
      _user =
          createdUser; //in the original version there is a setAddCurrentUser that I don't like it too much
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNote();

    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final dbuser = await getUser(email: owner.email);
    if (dbuser != owner) {
      throw CouldNotFindUser();
    }
    String text = '';
    final noteId = await db.insert(
      noteTable,
      {userIdCol: owner.id, textCol: text, isSynceWiothCloudCol: 1},
    );
    final note = DatabaseNote(
        id: noteId, userId: owner.id, text: text, isSynceWithCloud: true);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final deleteCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    if (deleteCount != 1) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((element) => element.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final deleteCounts = await db.delete(noteTable);
    if (deleteCounts == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes = [];
      _notesStreamController.add(_notes);
      return deleteCounts;
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final results =
        await db.query(noteTable, where: 'id=?', whereArgs: [id], limit: 1);
    if (results.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final user = DatabaseNote.fromRow(results.first);
      _notes.removeWhere((element) => element.id == id);
      _notes.add(user);
      _notesStreamController.add(_notes);
      return user;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final results = await db.query(noteTable);
    return results.map((note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> updateNote(
      {required String text, required DatabaseNote note}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    await getNote(id: note.id);
    final updatesCounts = await db.update(
      noteTable,
      {textCol: text, isSynceWiothCloudCol: 0},
      where: 'id=?',
      whereArgs: [note.id],
    );

    if (updatesCounts == 0) {
      devtools.log('error in update');
      throw CouldNotUpdateNote();
    } else {
      final noteUpdate = await getNote(id: note.id);
      _notes.removeWhere((element) => element.id == noteUpdate.id);
      _notes.add(noteUpdate);
      _notesStreamController.add(_notes);

      return noteUpdate;
    }
  }

  Database _getDbOrThrowIt() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw UserNotFoundAuthExceptions();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {emailCol: email.toLowerCase()});
    final createdUser = DatabaseUser(
      id: userId,
      email: email,
    );

    return createdUser;
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDbOrThrowIt();

    final deleteCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyIsOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyIsOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();

      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
         );''';
      db.execute(createUserTable);

      const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synce_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';
      db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw DatabaseAlreadyIsOpenException();
    }
  }
}

const dbName = 'note.db';
const userTable = 'user';
const noteTable = 'note';
const idCol = 'id';
const emailCol = 'email';
const userIdCol = 'user_id';
const textCol = 'text';
const isSynceWiothCloudCol = 'is_synce_with_cloud';
 */