import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();
  factory LocalDatabaseHelper() => _instance;
  LocalDatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user_profile.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_profile (
            uid TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertOrUpdateUserProfile(String uid, String name, String email,
      String phone, String imagePath) async {
    final db = await database;
    await db.insert(
      'user_profile',
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'imagePath': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'user_profile',
      where: "uid = ?",
      whereArgs: [uid],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
