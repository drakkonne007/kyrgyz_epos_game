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
    default: print('error name of World!'); return BigTopLeft();
  }
}


abstract class GameWorldData
{
  String source = '';
  String nameForGame = '';
  GameConsts gameConsts = GameConsts();
  OrientatinType orientation = OrientatinType.orthogonal;
}

class TestMap extends GameWorldData {
  TestMap()
  {
    orientation = OrientatinType.orthogonal;
    nameForGame = 'testMap';
    source = 'testMap.tmx';
    gameConsts = GameConsts(maxColumn: 3, maxRow:3);
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
    gameConsts = GameConsts(maxColumn: 10, maxRow:11);
  }
}

class TopLeftTempleDungeon extends GameWorldData {
  TopLeftTempleDungeon()
  {
    orientation = OrientatinType.orthogonal;
    nameForGame = 'topLeftTempleDungeon';
    source = 'topLeftTempleDungeon.tmx';
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
    gameConsts = GameConsts(maxColumn: 3, maxRow:2);
  }
}
