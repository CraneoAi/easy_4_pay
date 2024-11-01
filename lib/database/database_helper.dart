import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scheduled_payment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scheduled_payments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incrementamos la versión para el nuevo campo
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE scheduled_payments(
      _id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT NOT NULL,
      amount REAL NOT NULL,
      next_date TEXT NOT NULL,
      interval TEXT NOT NULL,
      category INTEGER NOT NULL DEFAULT 0
    )
    ''');
  }

  // Maneja la actualización de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agregar la columna category si no existe
      await db.execute('ALTER TABLE scheduled_payments ADD COLUMN category INTEGER NOT NULL DEFAULT 0');
    }
  }

  // Mantén tus métodos existentes
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('scheduled_payments', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await instance.database;
    return await db.query('scheduled_payments');
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['_id'];
    return await db.update(
      'scheduled_payments',
      row,
      where: '_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'scheduled_payments',
      where: '_id = ?',
      whereArgs: [id],
    );
  }

  // Agrega los nuevos métodos necesarios
  Future<List<ScheduledPayment>> getAllPayments() async {
    final List<Map<String, dynamic>> maps = await queryAllRows();
    
    return List.generate(maps.length, (i) {
      return ScheduledPayment.fromMap(maps[i]);
    });
  }

  Future<int> deletePayment(int id) async {
    return await delete(id);
  }

  Future<int> insertPayment(ScheduledPayment payment) async {
    return await insert(payment.toMap());
  }

  Future<int> updatePayment(ScheduledPayment payment) async {
    return await update(payment.toMap());
  }
}