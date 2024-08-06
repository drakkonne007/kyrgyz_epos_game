
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/Items/loot_list.dart';
import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/abstracts/quest.dart';
import 'package:game_flame/components/CountTimer.dart';
import 'package:game_flame/components/game_worlds.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EffectTimerPure
{
  double dur = 0;
  String parentId = '';
}

class SavedGame
{
  int saveId = 0;
  double x = 0;
  double y = 0;
  String world = '';
  double health = 0;
  double energy = 0;
  double level = 0;
  int gold = 0;
  List<String> currentInventar = [];
  Map<String,int> weaponInventar = {};
  Map<String,int> armorInventar  = {};
  Map<String,int> flaskInventar  = {};
  Map<String,int> itemInventar   = {};
  List<EffectTimerPure> tempEffects   = [];
}

class DBItemState
{
  bool opened = false;
  int quest = 0;
  bool used = false;
}

class DBQuestState
{
  int currentState = 0;
  bool isDone = false;
}

class DbHandler
{
  Database? _database;
  ValueNotifier<int> dbStateChanger = ValueNotifier(0);

  Future openDb() async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'kyrgyzGame.db');
    _database = await openDatabase(path, version: 18,
        onUpgrade: (Database db, int oldVersion, int newVersion) async{
          print('UPGRADE TABLES!!!');
          await dropAllTables();
          await createTable();
        },
        onCreate: (Database db, int v) async{
          print('CREATE TABLES!!!');
          await dropAllTables();
          await createTable();
        });
    try{
      await _database?.rawQuery('SELECT id FROM player_data LIMIT 1');
    }catch(e){
      await dropAllTables();
      await createTable();
    }
    // await _database?.execute('DELETE FROM travel_shop');
  }

  Future dropAllTables()async
  {
    for(final wrld in fullMaps()){
      await _database?.execute('DROP TABLE IF EXISTS ${wrld.nameForGame}');
    }
    await _database?.execute('DROP TABLE IF EXISTS player_data');
    await _database?.execute('DROP TABLE IF EXISTS current_inventar');
    await _database?.execute('DROP TABLE IF EXISTS inventar');
    await _database?.execute('DROP TABLE IF EXISTS effects');
    await _database?.execute('DROP TABLE IF EXISTS quests');
  }

  Future createTable() async
  {
    for(final wrld in fullMaps()){
      await _database?.execute('CREATE TABLE IF NOT EXISTS ${wrld.nameForGame} '
          '(id INTEGER PRIMARY KEY NOT NULL'
          ',save_id INT NOT NULL DEFAULT 0'
          ',opened INTEGER NOT NULL DEFAULT 0'
          ',quest INTEGER NOT NULL DEFAULT 0'
          ',used INTEGER NOY NULL DEFAULT 0'
          ');');
    }
    await _database?.execute('CREATE TABLE IF NOT EXISTS player_data '
        '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
        ',save_id INT NOT NULL DEFAULT 0'
        ',x double NOT NULL DEFAULT 0'
        ',y double NOT NULL DEFAULT 0'
        ',world TEXT NOT NULL'
        ',health double NOT NULL DEFAULT 0'
        ',energy double NOT NULL DEFAULT 0'
        ',level double NOT NULL DEFAULT 1'
        ',gold INTEGER NOT NULL DEFAULT 0'
        ');');
    await _database?.execute('CREATE TABLE IF NOT EXISTS current_inventar '
        '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
        ',save_id INT NOT NULL DEFAULT 0'
        ',name_id TEXT NOT NULL'
        ');');
    await _database?.execute('CREATE TABLE IF NOT EXISTS inventar '
        '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
        ',save_id INT NOT NULL DEFAULT 0'
        ',name_id TEXT NOT NULL'
        ',type TEXT NOT NULL' //Тип инвентаря - weapon,flask,armor,item
        ',count INT NOT NULL'
        ',count_of_use INT NOT NULL'
        ');');
    await _database?.execute('CREATE TABLE IF NOT EXISTS effects '
        '(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL'
        ',save_id INT NOT NULL DEFAULT 0'
        ',name_id TEXT NOT NULL'
        ',period double NOT NULL'
        ');');
    await _database?.execute('CREATE TABLE IF NOT EXISTS quests '
        '(name TEXT PRIMARY KEY NOT NULL'
        ',current_state INTEGER NOT NULL DEFAULT 0'
        ',is_done INTEGER NOT NULL DEFAULT 0'
        ');');
    print('All tables was created');
    await fillGameObjects();
    await fillQuests();
  }

  Future fillGameObjects() async
  {
    for(final wrld in fullMaps()){
      await _database?.execute('DELETE FROM ${wrld.nameForGame}');
      try {
        var data = await rootBundle.loadString(
            'assets/metaData/${wrld.nameForGame}/sqlObjects.sql', cache: false);
        var list = data.split('\n');
        for (final line in list) {
          if (line.length > 10) {
            await _database?.execute(line.replaceAll('""', '0'));
          }
        }
      }catch(e){}
    }
  }

  Future fillQuests() async
  {
    for(final name in Quest.allQuests){
      await _database?.rawInsert('INSERT INTO quests(name) VALUES(?) ON CONFLICT DO NOTHING', [name]);
    }
  }

  Future<bool> checkSaved(int saveId)async
  {
    final res = await _database?.rawQuery('SELECT id FROM player_data WHERE save_id = ?', [saveId]);
    return (res != null && res.isNotEmpty);
  }

  Future saveGame(int saveId, double x, double y, String world, double health, double energy, double level, int gold,
      Item helmetDress,
      Item armorDress,
      Item glovesDress,
      Item swordDress,
      Item ringDress,
      Item bootsDress,
      Map<String,int> weaponInventar,
      Map<String,int> armorInventar,
      Map<String,int> flaskInventar,
      Map<String,int> itemInventar,
      List<TempEffect> tempEffects)async
  {
    await _database?.rawDelete('DELETE FROM player_data WHERE save_id = ?', [saveId]);
    await _database?.rawInsert('INSERT INTO player_data(save_id,x,y,world,health,energy,level,gold) VALUES(?,?,?,?,?,?,?,?)', [saveId, x, y, world, health, energy, level, gold]);
    await _database?.execute('DELETE FROM current_inventar WHERE save_id = ?', [saveId]);
    await _database?.rawInsert('INSERT INTO current_inventar(save_id,name_id) VALUES(?,?)', [saveId, helmetDress.id]);
    await _database?.rawInsert('INSERT INTO current_inventar(save_id,name_id) VALUES(?,?)', [saveId, armorDress.id]);
    await _database?.rawInsert('INSERT INTO current_inventar(save_id,name_id) VALUES(?,?)', [saveId, glovesDress.id]);
    await _database?.rawInsert('INSERT INTO current_inventar(save_id,name_id) VALUES(?,?)', [saveId, swordDress.id]);
    await _database?.rawInsert('INSERT INTO current_inventar(save_id,name_id) VALUES(?,?)', [saveId, ringDress.id]);
    await _database?.rawInsert('INSERT INTO current_inventar(save_id,name_id) VALUES(?,?)', [saveId, bootsDress.id]);

    await _database?.execute('DELETE FROM inventar WHERE save_id = ?', [saveId]);
    for(final item in weaponInventar.keys){
      await _database?.rawInsert('INSERT INTO inventar(save_id,name_id,count,count_of_use,type) VALUES(?,?,?,?,?)', [saveId, item,weaponInventar[item],10,'weapon']);
    }
    for(final item in armorInventar.keys){
      await _database?.rawInsert('INSERT INTO inventar(save_id,name_id,count,count_of_use,type) VALUES(?,?,?,?,?)', [saveId, item,armorInventar[item],10,'armor']);
    }
    for(final item in flaskInventar.keys){
      await _database?.rawInsert('INSERT INTO inventar(save_id,name_id,count,count_of_use,type) VALUES(?,?,?,?,?)', [saveId, item,flaskInventar[item],10,'flask']);
    }
    for(final item in itemInventar.keys){
      await _database?.rawInsert('INSERT INTO inventar(save_id,name_id,count,count_of_use,type) VALUES(?,?,?,?,?)', [saveId, item,itemInventar[item],10,'item']);
    }
    await _database?.execute('DELETE FROM effects WHERE save_id = ?', [saveId]);
    for(final eff in tempEffects){
      await _database?.rawInsert('INSERT INTO effects(save_id,name_id,period) VALUES(?,?,?)', [saveId, eff.parentId, eff.timeBeforeEnd]);
    }
  }

  Future<SavedGame> loadGame(int saveId) async
  {
    SavedGame svGame = SavedGame();
    var res = await _database?.rawQuery('SELECT * FROM player_data where save_id = ? ORDER BY id DESC LIMIT 1', [saveId]);
    if(res == null) return svGame;
    svGame.x = res[0]['x']! as double;
    // svGame.x += 300;
    svGame.y = res[0]['y']! as double;
    svGame.world = res[0]['world']!.toString();
    svGame.health = res[0]['health']! as double;
    svGame.energy = res[0]['energy']! as double;
    svGame.level = res[0]['level']! as double;
    svGame.gold = res[0]['gold']! as int;

    res = await _database?.rawQuery('SELECT * FROM current_inventar where save_id = ?', [saveId]);
    if(res == null) return svGame;
    for(final item in res){
      svGame.currentInventar.add(item['name_id']!.toString());
    }

    res = await _database?.rawQuery('SELECT * FROM inventar where save_id = ?', [saveId]);
    if(res == null) return svGame;
    for(final item in res){
      switch(item['type']!.toString()){
        case 'weapon': svGame.weaponInventar[item['name_id']!.toString()] = item['count']! as int; break;
        case 'armor': svGame.armorInventar[item['name_id']!.toString()] = item['count']! as int; break;
        case 'flask': svGame.flaskInventar[item['name_id']!.toString()] = item['count']! as int; break;
        case 'item': svGame.itemInventar[item['name_id']!.toString()] = item['count']! as int; break;
      }
    }

    res = await _database?.rawQuery('SELECT * FROM effects where save_id = ?', [saveId]);
    if(res == null) return svGame;
    for(final item in res){
      EffectTimerPure pr = EffectTimerPure();
      pr.dur = item['period']! as double;
      pr.parentId = item['name_id']!.toString();
      svGame.tempEffects.add(pr);
    }
    return svGame;
  }

  Future changeItemState({required int id, String? openedAsString, String? quest, String? usedAsString, required String worldName})async
  {
    final res = await _database?.rawQuery('SELECT * FROM $worldName where id = ?', [id]);
    await _database?.rawUpdate('UPDATE $worldName set opened = ?, quest = ?, used = ? where id = ?',
        [openedAsString ?? res![0]['opened'].toString(), quest ?? res![0]['quest'].toString(), usedAsString ?? res![0]['used'].toString(), id]);
    dbStateChanger.notifyListeners();
  }

  Future<DBItemState> getItemStateFromDb(int id, String worldName)async
  {
    DBItemState answer = DBItemState();
    final res = await _database?.rawQuery('SELECT * FROM $worldName where id = ?', [id]);
    if(res == null || res.isEmpty) {
      throw 'ERROR in SELECT * FROM $worldName where id = ?';
    }
    answer.opened = res[0]['opened'].toString() == '1';
    answer.quest = int.tryParse(res[0]['quest'].toString()) ?? 0;
    answer.used = res[0]['used'].toString() == '1';
    return answer;
  }

  Future<DBQuestState> getQuestState(String name)async
  {
    final res = await _database?.rawQuery(
        'SELECT * FROM quests WHERE name = ?',[name]);
    if (res == null || res.isEmpty) {
      throw 'No find this quest!!! $name';
    }
    DBQuestState answer = DBQuestState();
    answer.currentState = int.tryParse(res[0]['current_state'].toString()) ?? 0;
    answer.isDone = res[0]['is_done'].toString() == '1';
    return answer;
  }

  Future setQuestState(String name, int state, bool isDone)async
  {
    await _database?.rawUpdate('UPDATE quests set is_done = ?, current_state = ? where name = ?',[isDone ? 1 : 0, state, name]);
  }
}