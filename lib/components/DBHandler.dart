
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBAnswer
{
  bool opened = true;
  int quest = 0;
  bool used = false;
}

class DbHandler
{
  Database? _database;
  ValueNotifier<int> dbStateChanger = ValueNotifier(0);

  Future openDb() async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'kyrgyzGame.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int v) {

          for(final wrld in fullMaps()){
          db.execute('CREATE TABLE IF NOT EXISTS ${wrld.nameForGame} '
              '(id INTEGER PRIMARY KEY NOT NULL'
              ',opened INTEGER NOT NULL DEFAULT 1'
              ',quest INTEGER NOT NULL DEFAULT 0'
              ',used INTEGER NOY NULL DEFAULT 0'
              ');');
          }

          db.execute('CREATE TABLE IF NOT EXISTS player_data '
              '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
              ',save_id INT NOT NULL'
              ',x double NOT NULL DEFAULT 0'
              ',y double NOT NULL DEFAULT 0'
              ',world TEXT NOT NULL DEFAULT ""'
              ',health double NOT NULL DEFAULT 0'
              ',energy double NOT NULL DEFAULT 0'
              ',level double NOT NULL DEFAULT 1'
              ',gold NOT NULL DEFAULT 0'
              ');');

          db.execute('CREATE TABLE IF NOT EXISTS inventar '
              '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
              ',name_id TEXT NOT NULL'
              ',count INT NOT NULL'
              ',count_of_use INT NOT NULL'
              ');');

          db.execute('CREATE TABLE IF NOT EXISTS effects '
              '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
              ',name_id TEXT NOT NULL'
              ',period double NOT NULL'
              ');');

          fillGameObjects();
        });
    // await _database?.execute('DELETE FROM travel_shop');
  }

  void createFakeObject()
  {
    _database?.rawInsert('INSERT INTO topLeftTempleDungeon (id, opened, quest, used) VALUES (1753, 0, 0, 0) ON CONFLICT DO NOTHING');
  }

  void fillGameObjects() async
  {
    var dir = await getApplicationSupportDirectory();
    for(final wrld in fullMaps()){
      File file = File('${dir.path}/${wrld.nameForGame}/sqlObjects.sql');
      if(file.existsSync()){
        await _database?.execute(file.readAsStringSync());
      }
    }
  }

  void changeState({required int id, String? openedAsInt, String? quest, String? usedAsInt})
  {
    _database?.rawQuery('SELECT * FROM topLeftTempleDungeon where id = ?', [id]).then((value) {
      print('change State id = $id, openedAsInt = $openedAsInt, quest = $quest, usedAsInt = $usedAsInt');
      _database?.rawUpdate('UPDATE topLeftTempleDungeon set opened = ?, quest = ?, used = ? where id = ?',
          [openedAsInt ?? value[0]['opened'].toString(), quest ?? value[0]['quest'].toString(), usedAsInt ?? value[0]['used'].toString(), id.toString()]);
      dbStateChanger.notifyListeners();
    });
  }

  Future<DBAnswer> stateFromDb(int id)async
  {
    DBAnswer answer = DBAnswer();
    final res = await _database?.rawQuery('SELECT * FROM topLeftTempleDungeon where id = ?', [id]);
    if(res == null) return answer;
    answer.opened = res[0]['opened'].toString()  == '1';
    answer.quest = int.parse(res[0]['quest'].toString());
    answer.used = res[0]['used'].toString() == '1';
    return answer;
  }
}