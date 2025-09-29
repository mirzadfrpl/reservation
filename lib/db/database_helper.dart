import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ecommerce/models/restaurant_favourite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'favorites';

  Future<Database> _initializeDb() async {
    var db = await openDatabase(
      join(await getDatabasesPath(), 'restaurant_db.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableName(
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating REAL
        )''');
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertFavorite(FavoriteRestaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableName,
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FavoriteRestaurant>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return FavoriteRestaurant.fromMap(maps[i]);
    });
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
