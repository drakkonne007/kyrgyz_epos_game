import 'package:flame/components.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;

List<GameWorldData> fullMaps()
{
  List<GameWorldData> list = [];
  list.add(TestMap());
  list.add(TopLeftVillage());
  list.add(BigTopLeft());
  list.addAll(getVillages());
  list.add(TopLeftTempleDungeon());
  list.add(TampleDungeon());
  list.add(TampleDungeon2Floor());
  list.add(CaveUnderRiver());
  list.add(CaveUnderRiver2());
  list.add(CaveUnderRiver3());
  list.add(CaveUnderRiver4());
  list.add(UnderTampleRoom());
  return list;
}

List<GameWorldData> fullMapsForPreCompille()
{
  List<GameWorldData> list = [];
  list.add(TestMap());
  list.add(TopLeftVillage());
  list.add(BigTopLeft());
  // list.addAll(getVillages());
  // list.add(TopLeftTempleDungeon());
  // list.add(TampleDungeon());
  // list.add(TampleDungeon2Floor());
  // list.add(CaveUnderRiver());
  // list.add(CaveUnderRiver2());
  // list.add(CaveUnderRiver3());
  // list.add(CaveUnderRiver4());
  list.add(UnderTampleRoom());
  return list;
}

enum OrientatinType
{
  orthogonal,
  front
}

GameWorldData getWorldFromName(String name)
{
  if(name.startsWith('yurtaInTopLeftVillage')){
    final int id = int.parse(name.split('yurtaInTopLeftVillage')[1]);
    return YurtaInTopLeftVillage(id);
  }
  switch(name){
    case 'topLeftVillage': return TopLeftVillage();
    case 'topLeft': return BigTopLeft();
    case 'topLeftTempleDungeon': return TopLeftTempleDungeon();
    case 'testMap': return TestMap();
    case 'dungeonUnderTemple': return TampleDungeon();
    case 'dungeonUnderTemple2Floor': return TampleDungeon2Floor();
    case 'caveUnderRiver': return CaveUnderRiver();
    case 'caveUnderRiver2': return CaveUnderRiver2();
    case 'caveUnderRiver3': return CaveUnderRiver3();
    case 'caveUnderRiver4': return CaveUnderRiver4();
    case 'underTampleRoom': return UnderTampleRoom();
    default: print('error name of World!'); return BigTopLeft();
  }
}


abstract class GameWorldData
{
  String source = '';
  String nameForGame = '';
  GameConsts gameConsts = GameConsts(Vector2(297,297));
  OrientatinType orientation = OrientatinType.orthogonal;
  int _currentText = 0;
  List<String> mapSmallDialogs = [];
  bool isDungeon = false;

  GameWorldData()
  {
    if(mapSmallDialogs.isNotEmpty){
      _currentText = math.Random().nextInt(mapSmallDialogs.length);
    }
  }

  String? getSmallMapDialog()
  {
    if(mapSmallDialogs.isEmpty){
      return null;
    }
    if(_currentText >= mapSmallDialogs.length){
      _currentText = 0;
    }
    return mapSmallDialogs[_currentText++];
  }
}

class TestMap extends GameWorldData {
  TestMap()
  {
    orientation = OrientatinType.orthogonal;
    nameForGame = 'testMap';
    source = 'testMap.tmx';
    gameConsts = GameConsts(Vector2(33,27));
    mapSmallDialogs = [
      'Здесь еcть прекрасный храм, вверху и слева',
      'Можно легко заблудиться в этих местах',
      'Эта большая равнина хранит в себе много загадок',
      'Здесь нет особых правил, караванам надо передвигаться аккуратно',
      'Реку можно перейти в другом месте, или найти лодку. Но я не знаю где её взять',
    ];
  }
}

class BigTopLeft extends GameWorldData
{
  BigTopLeft()
  {
    orientation = OrientatinType.orthogonal;
    nameForGame = 'topLeft';
    source = 'top_left_bottom-slice.tmx';
    mapSmallDialogs = [
      'Здесь еcть прекрасный храм, вверху и слева',
      'Можно легко заблудиться в этих местах',
      'Эта большая равнина хранит в себе много загадок',
      'Здесь нет особых правил, караванам надо передвигаться аккуратно',
      'Реку можно перейти в другом месте, или найти лодку. Но я не знаю где её взять',
    ];
  }
}

class TopLeftVillage extends GameWorldData {
  TopLeftVillage()
  {
    orientation = OrientatinType.orthogonal;
    nameForGame = 'topLeftVillage';
    source = 'top_left_village.tmx';
    gameConsts = GameConsts(Vector2(110,99));
    mapSmallDialogs = [
      'Наша деревня слваится своим садом недалеко от реки',
      'Не топчите огороды, если хотите перенять наш опыт выращивания овощей',
      'Мы возвели большие стены, и на нас давно никто не нападал',
      'Можете погреться у костра или зайти к кузнецу, он живёт от входа направо',
    ];
  }
}

class TampleDungeon extends GameWorldData {
  TampleDungeon()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'dungeonUnderTemple';
    source = 'dungeonUnderTemple.tmx';
    gameConsts = GameConsts(Vector2(110,99));
    mapSmallDialogs = [
      'Жууууткое место',
    ];
  }
}

class TampleDungeon2Floor extends GameWorldData {
  TampleDungeon2Floor()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'dungeonUnderTemple2Floor';
    source = 'dungeonUnderTemple2Floor.tmx';
    gameConsts = GameConsts(Vector2(80,62));
    mapSmallDialogs = [
      'Жууууткое место',
    ];
  }
}

class TopLeftTempleDungeon extends GameWorldData {
  TopLeftTempleDungeon()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'topLeftTempleDungeon';
    source = 'topLeftTempleDungeon.tmx';
    mapSmallDialogs = [
      'Здесь довольно опасно...',
      'Здесь есть не только враждебные, но и дружелюбные монстры',
      'Открывайте сундуки, их здесь много',
      'Здешние скелеты захватили деревянный аванпост, там теперь очень опасно',
      'Остерегайтесь катящихся брёвен, они сбивают всё на своём пути'
    ];
  }
}

class UnderTampleRoom extends GameWorldData {
  UnderTampleRoom()
  {
    isDungeon = false;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'underTampleRoom';
    source = 'underTampleRoom.tmx';
    mapSmallDialogs = [
      'Здесь довольно опасно...',
      'Здесь есть не только враждебные, но и дружелюбные монстры',
      'Открывайте сундуки, их здесь много',
      'Здешние скелеты захватили деревянный аванпост, там теперь очень опасно',
      'Остерегайтесь катящихся брёвен, они сбивают всё на своём пути'
    ];
    gameConsts = GameConsts(Vector2(50,50));
  }
}

class CaveUnderRiver extends GameWorldData {
  CaveUnderRiver()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'caveUnderRiver';
    source = 'caveUnderRiver.tmx';
    mapSmallDialogs = [
      'Здесь довольно опасно...',
      'Здесь есть не только враждебные, но и дружелюбные монстры',
      'Открывайте сундуки, их здесь много',
      'Здешние скелеты захватили деревянный аванпост, там теперь очень опасно',
      'Остерегайтесь катящихся брёвен, они сбивают всё на своём пути'
    ];
    gameConsts = GameConsts(Vector2(110,99));
  }
}

class CaveUnderRiver2 extends GameWorldData {
  CaveUnderRiver2()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'caveUnderRiver2';
    source = 'caveUnderRiver2.tmx';
    mapSmallDialogs = [
      'Здесь довольно опасно...',
      'Здесь есть не только враждебные, но и дружелюбные монстры',
      'Открывайте сундуки, их здесь много',
      'Здешние скелеты захватили деревянный аванпост, там теперь очень опасно',
      'Остерегайтесь катящихся брёвен, они сбивают всё на своём пути'
    ];
    gameConsts = GameConsts(Vector2(110,99));
  }
}

class CaveUnderRiver3 extends GameWorldData {
  CaveUnderRiver3()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'caveUnderRiver3';
    source = 'caveUnderRiver3.tmx';
    mapSmallDialogs = [
      'Здесь довольно опасно...',
      'Здесь есть не только враждебные, но и дружелюбные монстры',
      'Открывайте сундуки, их здесь много',
      'Здешние скелеты захватили деревянный аванпост, там теперь очень опасно',
      'Остерегайтесь катящихся брёвен, они сбивают всё на своём пути'
    ];
    gameConsts = GameConsts(Vector2(110,99));
  }
}

class CaveUnderRiver4 extends GameWorldData {
  CaveUnderRiver4()
  {
    isDungeon = true;
    orientation = OrientatinType.orthogonal;
    nameForGame = 'caveUnderRiver4';
    source = 'caveUnderRiver4.tmx';
    mapSmallDialogs = [
      'Здесь довольно опасно...',
      'Здесь есть не только враждебные, но и дружелюбные монстры',
      'Открывайте сундуки, их здесь много',
      'Здешние скелеты захватили деревянный аванпост, там теперь очень опасно',
      'Остерегайтесь катящихся брёвен, они сбивают всё на своём пути'
    ];
    gameConsts = GameConsts(Vector2(150,150));
  }
}


List<GameWorldData> getVillages({List<int>? numbers})
{
  List<GameWorldData> list = [];
  if(numbers != null){
    for(final num in numbers){
      list.add(YurtaInTopLeftVillage(num));
    }
  }else{
    for(int i=0;i<12;i++){
      list.add(YurtaInTopLeftVillage(i));
    }
  }
  return list;
}

class YurtaInTopLeftVillage extends GameWorldData {
  YurtaInTopLeftVillage(int number)
  {
    orientation = OrientatinType.front;
    nameForGame = 'yurtaInTopLeftVillage$number';
    source = 'yurtaInTopLeftVillage$number.tmx';
    gameConsts = GameConsts(Vector2(33,18));
  }
}
