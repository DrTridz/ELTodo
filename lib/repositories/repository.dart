import 'db_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository{

  DatabaseConnection _connection;

  Repository(){
    _connection = DatabaseConnection();
  }
  static Database _database;
  Future<Database> get database async{
    if(_database != null)return _database;
    _database = await _connection.setDatabase();
    return _database;
  }
  save(table, data)async{
    var conn = await database;
    return await conn.insert(table, data);
  }
  getAll(table) async{
    var conn = await database;
    return await conn.query(table);
  }

  getById(String table, itemId) async{
    var conn = await database;
    return await conn.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  update(String table, data)async {
    var conn = await database;
    return await conn.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  delete(String table, itemId) async{
    var conn = await database;
    return await conn.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }

  getByColumnName(String table, String columnName, String columnValue)async {
    var conn = await database;
    return await conn.query(table, where: '$columnName = ?', whereArgs: [columnValue]);
  }
}