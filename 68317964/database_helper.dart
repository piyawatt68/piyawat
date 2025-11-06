import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// อย่าลืม import ไฟล์โมเดลที่เราสร้างไว้
import 'volcanic_eruption.dart'; 

class DatabaseHelper {
  static const _databaseName = "VolcanoEruptionDB.db";
  static const _databaseVersion = 1;

  static const table = 'eruption_log'; // ชื่อตาราง
  
  // ชื่อคอลัมน์
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnLocation = 'location';
  static const columnDate = 'eruptionDate';
  static const columnVei = 'vei';
  static const columnStatus = 'status';

  // สร้างเป็น Singleton Class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // เปิดฐานข้อมูล
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL สำหรับสร้างตาราง (ปรับตาม 5 attributes)
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnLocation TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnVei INTEGER NOT NULL,
            $columnStatus TEXT NOT NULL
          )
          ''');
  }

  // --- CRUD Methods (ปรับให้รับ/ส่ง VolcanicEruption) ---

  // Create: เพิ่มข้อมูล
  Future<int> insert(VolcanicEruption eruption) async {
    Database db = await instance.database;
    Map<String, dynamic> row = eruption.toMap();
    row.remove('id'); // ให้ DB สร้าง id ให้อัตโนมัติ
    return await db.insert(table, row);
  }

  // Read (All): ดึงข้อมูลทั้งหมด
  Future<List<VolcanicEruption>> queryAllEruptions() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnDate DESC");
    
    List<VolcanicEruption> list = res.isNotEmpty
        ? res.map((c) => VolcanicEruption.fromMap(c)).toList()
        : [];
    return list;
  }
  
  // Update: แก้ไขข้อมูล
  Future<int> update(VolcanicEruption eruption) async {
    Database db = await instance.database;
    int id = eruption.id!;
    return await db.update(table, eruption.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete: ลบข้อมูล
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}