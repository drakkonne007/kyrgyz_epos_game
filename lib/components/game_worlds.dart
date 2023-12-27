import 'package:game_flame/components/physic_vals.dart';

List<GameWorldData> fullMaps =
[
  TopLeftVillage(),
  BigTopLeft(),
  YurtaInTopLeftVillage1(),
  TopLeftTempleDungeon(),
];

List<GameWorldData> fullMapsForPreCompille =
[
  TopLeftVillage(),
  BigTopLeft(),
  YurtaInTopLeftVillage1(),
  TopLeftTempleDungeon(),
];

enum OrientatinType
{
  orthogonal,
  front
}

GameWorldData getWorldFromName(String name)
{
  print('name $name');
  switch(name){
    case 'topLeftVillage': return TopLeftVillage();
    case 'topLeft': return BigTopLeft();
    case 'yurtaInTopLeftVillage1': return YurtaInTopLeftVillage1();
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
    orientation = OrientatinType.front;
    nameForGame = 'topLeftTempleDungeon';
    source = 'topLeftTempleDungeon.tmx';
    gameConsts = GameConsts(maxColumn: 10, maxRow:11);
  }
}

class YurtaInTopLeftVillage1 extends GameWorldData {
  YurtaInTopLeftVillage1()
  {
    orientation = OrientatinType.front;
    nameForGame = 'yurtaInTopLeftVillage1';
    source = 'yurtaInTopLeftVillage1.tmx';
    gameConsts = GameConsts(maxColumn: 3, maxRow:2);
  }
}


