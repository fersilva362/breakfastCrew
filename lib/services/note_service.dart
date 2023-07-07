import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

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
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDbOrThrowIt();
    final dbuser = await getUser(email: owner.email);
    if (dbuser == owner) {
      throw CouldNotFindUser();
    }
    String text = '';
    final id = await db.insert(
      noteTable,
      {userIdCol: owner.id, textCol: text, isSynceWiothCloudCol: 1},
    );
    final note = DatabaseNote(
        id: id, userId: owner.id, text: text, isSynceWithCloud: true);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDbOrThrowIt();
    final deleteCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    if (deleteCount != 1) {
      throw CouldNotDeleteNote();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDbOrThrowIt();
    final deleteCounts = await db.delete(noteTable);
    if (deleteCounts == 0) {
      throw CouldNotDeleteNote();
    }
    return deleteCounts;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDbOrThrowIt();
    final results =
        await db.query(noteTable, where: 'id=?', whereArgs: [id], limit: 1);
    if (results.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(results.first);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = _getDbOrThrowIt();
    final results = await db.query(noteTable);
    return results.map((note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> updateNote(
      {required String text, required DatabaseNote note}) async {
    final db = _getDbOrThrowIt();
    await getNote(id: note.id);
    final updatesCounts = await db.update(
      noteTable,
      {textCol: text, isSynceWiothCloudCol: 0},
    );
    if (updatesCounts == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
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
    final db = _getDbOrThrowIt();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDbOrThrowIt();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {emailCol: email.toLowerCase()});
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
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

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyIsOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      const createUserTable = '''CREATE TABLE IF NOT EXIST "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id")
         );''';
      db.execute(createUserTable);

      const createNoteTable = '''CREATE TABLE IF NOT EXIST "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT NOT NULL,
        "is_synce_with_cloud"	INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';
      db.execute(createNoteTable);
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
