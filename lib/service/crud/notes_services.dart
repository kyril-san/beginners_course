import 'package:beginners_course/service/crud/crud_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db;

  Future<DatabaseNotes> updateNotes(
      {required DatabaseNotes note, required String text}) async {
    final db = _getDatabaseorThrow();
    await fetchNote(id: note.id);
    final updatedcount = await db.update(noteTable, {
      'text': text,
      'issynchedwithcloud': 0,
    });
    if (updatedcount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await fetchNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNotes>> getallNotes() async {
    final db = _getDatabaseorThrow();
    final notes = await db.query(noteTable);

    final results = notes.map((e) => DatabaseNotes.fromMap(e));

    return results;
  }

  Future<DatabaseNotes> fetchNote({required int id}) async {
    final db = _getDatabaseorThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFIneNotes();
    } else {
      return DatabaseNotes.fromMap(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseorThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseorThrow();
    final deletedcount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedcount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNotes> createnote({required DatabaseUser owner}) async {
    final db = _getDatabaseorThrow();

//make sure owner exists in the databse with correct id
    final dbuser = await getUser(email: owner.email);
    if (dbuser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    // create the notes

    final noteId = await db.insert(noteTable, {
      'userid': owner.id,
      'text': text,
      'issyncedwithcloud': 1,
    });
    final note = DatabaseNotes(
        id: noteId, userid: owner.id, text: text, issyncedwithcloud: 1);

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseorThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromMap(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseorThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userid = await db.insert(userTable, {
      'email': email.toLowerCase(),
    });
    return DatabaseUser(id: userid, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseorThrow();
    final deletedcount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (deletedcount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseorThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
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
      throw DatabaseALreadyOpenException();
    }
    try {
      final docspath = await getApplicationCacheDirectory();
      final dbpath = join(docspath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createnoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  factory DatabaseUser.fromMap(Map<String, dynamic> map) {
    return DatabaseUser(
      id: map['id'] as int,
      email: map['email'] as String,
    );
  }

  @override
  String toString() => 'DatabaseUser(id: $id, email: $email)';

  @override
  bool operator ==(covariant DatabaseUser other) {
    if (identical(this, other)) return true;

    return other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNotes {
  final int id;
  final int userid;
  final String text;
  final int issyncedwithcloud;
  const DatabaseNotes({
    required this.id,
    required this.userid,
    required this.text,
    required this.issyncedwithcloud,
  });

  factory DatabaseNotes.fromMap(Map<String, dynamic> map) {
    return DatabaseNotes(
      id: map['id'] as int,
      userid: map['userid'] as int,
      text: map['text'] as String,
      issyncedwithcloud: map['issyncedwithcloud'] as int,
    );
  }

  @override
  bool operator ==(covariant DatabaseNotes other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userid == userid &&
        other.text == text &&
        other.issyncedwithcloud == issyncedwithcloud;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DatabaseNotes(id: $id, userid: $userid, text: $text, issyncedwithcloud: $issyncedwithcloud)';
  }
}

const dbName = 'notes.db';
const userTable = 'user';
const noteTable = 'note';

const createUserTable = ''' CREATE TABLE IF NOT EXISTS"user" (
	"ID"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("ID" AUTOINCREMENT)
); ''';

const createnoteTable = ''' CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_server"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "user"("ID")
);''';
