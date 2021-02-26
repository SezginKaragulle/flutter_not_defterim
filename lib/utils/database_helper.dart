import 'dart:io';
import 'dart:async';
import 'package:flutter_not_defterim/models/kategori.dart';
import 'package:flutter_not_defterim/models/notlar.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper
{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  factory DatabaseHelper()
  {
    if(_databaseHelper  == null)
    {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    }
    else{
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database>  _getDatabase() async
  {
    if(_database == null)
    {
      _database = await _initializeDatabase();
      return _database;
    }
    else{
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {

    Database _db;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "ogrenci.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notlar.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);

  }
// kategori bilgisini getirecek kod blogu
  Future<List<Map<String,dynamic>>> kategorileriGetir() async
  {
      var db = await _getDatabase();
      var sonuc = await db.query("kategori");
      return sonuc;
  }

  //Kategori Bilgisini Eklemek İçin
  Future<int> kategoriEkle(Kategori kategori) async{
    var db= await _getDatabase();
    var sonuc = await db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  //Kategori Bilgisini Güncellemek İçin
  Future<int> kategoriGuncelle(Kategori kategori) async{
    var db= await _getDatabase();
    var sonuc = await db.update("kategori", kategori.toMap(), where: 'kategoriID = ?', whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  //Kategori Bilgisini Silmek İçin
  Future<int> kategoriSil(int kategoriID) async{
    var db= await _getDatabase();
    var sonuc = await db.delete("kategori", where: 'kategoriID = ?', whereArgs: [kategoriID]);
    return sonuc;
  }


//Not Bilgisini Listelemek İçin
  Future<List<Map<String,dynamic>>> notlariGetir() async{
    var db= await _getDatabase();
    var sonuc = await db.rawQuery('select * from "not" inner join kategori on kategori.kategoriID = "not".kategoriID order by notID Desc;');
    return sonuc;
  }
//Not Bilgisini Listelemek İçin 2
  Future<List<Not>> notListesiniGetir() async{
    var notlarMapListesi =  await notlariGetir();
    var notListesi = List<Not>();
    for(Map map in notlarMapListesi){
      notListesi.add(Not.fromMap(map));
    }
    return notListesi;
  }

//Not Bilgisini Eklemek İçin
  Future<int> notEkle(Not not) async{
    var db= await _getDatabase();
    var sonuc = await db.insert("not", not.toMap());
    return sonuc;
  }

  //Not Bilgisini Güncellemek İçin
  Future<int> notGuncelle(Not not) async{
    var db= await _getDatabase();
    var sonuc = await db.update("not", not.toMap(), where: 'notID = ?', whereArgs: [not.notID]);
    return sonuc;
  }
  //Not Bilgisini Silmek İçin
  Future<int> notSil(int notID) async{
    var db= await _getDatabase();
    var sonuc = await db.delete("not", where: 'notID = ?', whereArgs: [notID]);
    return sonuc;
  }


  String dateFormat(DateTime dt)
  {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (dt.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(dt);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (dt.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (dt.year == today.year) {
      return '${dt.day} $month';
    } else {
      return '${dt.day} $month ${dt.year}';
    }
    return "";
  }

  Future<List<Kategori>> kategoriListesiniGetir() async{

    var kategorileriIcerenMapListesi = await kategorileriGetir();
    var kategoriListesi = List<Kategori>();
    for(Map map in kategorileriIcerenMapListesi){
      kategoriListesi.add(Kategori.fromMap(map));
    }
    return kategoriListesi;

  }




}