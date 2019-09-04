import 'package:currency_convertor/UI/Model/Rate.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'Constants.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager.internal();

  factory DatabaseManager() => _instance;

  DatabaseManager.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "rates.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE ${Constants.RATES_TABLES} (${Constants.ID_COLUMN} INTEGER PRIMARY KEY, ${Constants.CURRENCY_CODE_COLUMN} TEXT, ${Constants.VALUE_COLUMN} TEXT, ${Constants.NAME_EN_COLUMN} TEXT, ${Constants.NAME_PT_COLUMN} TEXT, ${Constants.SYMBOL_COLUMN} TEXT, ${Constants.ALL_CURRENCIES_COLUMN} INTEGER, ${Constants.MOST_VALUABLE_COLUMN} INTEGER, ${Constants.CRYPTO_COLUMN} INTEGER, ${Constants.MOST_TRADED_COLUMN} INTEGER, ${Constants.IMG_COLUMN} TEXT)");
    });
  }

  Future<Rate> saveRate(Rate rate) async {
    Database dbRate = await db;
    rate.id =
    await dbRate.insert(Constants.RATES_TABLES, rate.toMap());
    return rate;
  }

  void restoreRate(Rate rate) async {
    Database dbRate = await db;
    await dbRate.insert(Constants.RATES_TABLES, rate.toMap());
  }

  Future<Rate> getRate(int id) async {
    Database dbRate = await db;
    List<Map> maps = await dbRate.query(Constants.RATES_TABLES,
        columns: [
          Constants.ID_COLUMN,
          Constants.CURRENCY_CODE_COLUMN,
          Constants.VALUE_COLUMN,
          Constants.NAME_EN_COLUMN,
          Constants.NAME_PT_COLUMN,
          Constants.SYMBOL_COLUMN,
          Constants.ALL_CURRENCIES_COLUMN,
          Constants.MOST_VALUABLE_COLUMN,
          Constants.CRYPTO_COLUMN,
          Constants.MOST_TRADED_COLUMN,
          Constants.IMG_COLUMN
        ],
        where: "${Constants.ID_COLUMN} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Rate.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Rate> getRateByCode(String code) async {
    Database dbRate = await db;
    List<Map> maps = await dbRate.query(Constants.RATES_TABLES,
        columns: [
          Constants.ID_COLUMN,
          Constants.CURRENCY_CODE_COLUMN,
          Constants.VALUE_COLUMN,
          Constants.NAME_EN_COLUMN,
          Constants.NAME_PT_COLUMN,
          Constants.SYMBOL_COLUMN,
          Constants.ALL_CURRENCIES_COLUMN,
          Constants.MOST_VALUABLE_COLUMN,
          Constants.CRYPTO_COLUMN,
          Constants.MOST_TRADED_COLUMN,
          Constants.IMG_COLUMN
        ],
        where: "${Constants.CURRENCY_CODE_COLUMN} = ?",
        whereArgs: [code]);
    if (maps.length > 0) {
      return Rate.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRate(int id) async {
    Database dbRate = await db;
    return await dbRate.delete(Constants.RATES_TABLES,
        where: "${Constants.ID_COLUMN} = ?", whereArgs: [id]);
  }

  Future<int> updateRate(Rate rate) async {
    Database dbRate = await db;
    return await dbRate.update(Constants.RATES_TABLES, rate.toMap(),
        where: "${Constants.CURRENCY_CODE_COLUMN} = ?", whereArgs: [rate.code]);
  }

  Future<Map> getAllRates() async {
    Database dbRate = await db;
    List listMap =
        await dbRate.rawQuery("SELECT * FROM ${Constants.RATES_TABLES}");
    Map<String, dynamic> map = {
      "rates": listMap
    };
    return map;
  }

  Future<int> deleteAllRates() async {
    Database dbRate = await db;
    return await dbRate.rawDelete("DELETE FROM ${Constants.RATES_TABLES}");
  }

  Future<int> getNumber() async {
    Database dbRate = await db;
    return Sqflite.firstIntValue(await dbRate
        .rawQuery("SELECT COUNT(*) FROM ${Constants.RATES_TABLES}"));
  }

  void checkIfRateExists(Rate r) async{
    Database dbRate = await db;
    List<Map> maps = await dbRate.query(Constants.RATES_TABLES,
        columns: [
          Constants.CURRENCY_CODE_COLUMN,
        ],
        where: "${Constants.CURRENCY_CODE_COLUMN} = ?",
        whereArgs: [r.code]);
    if (maps.length > 0) {
     updateRate(r);
    } else {
      saveRate(r);
    }
  }

  Future close() async {
    Database dbRate = await db;
    dbRate.close();
  }
}
