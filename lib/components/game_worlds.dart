import 'package:flame/components.dart';
import 'package:game_flame/components/physic_vals.dart';

List<GameWorldData> fullMaps()
{
  List<GameWorldData> list = [];
  list.add(TopLeftVillage());
  list.add(BigTopLeft());
  list.addAll(getVillages());
  list.add(TopLeftTempleDungeon());
  list.add(TestMap());
  return list;
}

List<GameWorldData> fullMapsForPreCompille()
{
  List<GameWorldData> list = [];
  list.add(TestMap());
  list.add(TopLeftVillage());
  list.add(BigTopLeft());
  list.addAll(getVillages());
  list.add(TopLeftTempleDungeon());
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
    default: print('error name of World!'); return BigTopLeft();
  }
}


abstract class GameWorldData
{
  String source = '';
  String nameForGame = '';
  GameConsts gameConsts = GameConsts();
  OrientatinType orientation = OrientatinType.orthogonal;
  int _currentText = 0;
  List<String> mapSmallDialogs = [];

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
    gameConsts = GameConsts(maxColumn: 3, maxRow:4, visibleBounds: Vector2(33,27));
    mapSmallDialogs = [
      'Здесь еть прекрасный храм, вверху и слева',
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
  }
}

class TopLeftVillage extends GameWorldData {
  TopLeftVillage()
  {
    orientation = OrientatinType.orthogonal;
    nameForGame = 'topLeftVillage';
    source = 'top_left_village.tmx';
    gameConsts = GameConsts(maxColumn: 10, maxRow:15,visibleBounds: Vector2(110,99));
    mapSmallDialogs = [
      'Наша деревня слваится своим садом недалеко от реки',
      'Не топчите огороды, если хотите перенять наш опыт выращивания овощей',
      'Мы возвели большие стены, и на нас давно никто не нападал',
      'Можете погреться у костра или зайти к кузнецу, он живёт от входа направо',
    ];
  }
}

class TopLeftTempleDungeon extends GameWorldData {
  TopLeftTempleDungeon()
  {
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
    gameConsts = GameConsts(maxColumn: 3, maxRow:3, visibleBounds: Vector2(33,18));
  }
}
