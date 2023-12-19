import 'package:game_flame/components/physic_vals.dart';

List<GameWorldData> fullMaps =
[
  TopLeftVillage(),
  BigTopLeft(),
];

GameWorldData getWorldFromName(String name)
{
  print('name $name');
  switch(name){
    case 'topLeftVillage': return TopLeftVillage();
    case 'topLeft': return BigTopLeft();
    default: return BigTopLeft();
  }
}



abstract class GameWorldData
{
  String source = '';
  String nameForGame = '';
  final GameConsts gameConsts = GameConsts();
}


class BigTopLeft implements GameWorldData
{
  @override
  String nameForGame = 'topLeft';//'top_left_bottom-slice.tmx';

  @override
  String source = 'top_left_bottom-slice.tmx';

  @override
  GameConsts gameConsts = GameConsts();

}

class TopLeftVillage implements GameWorldData {
  @override
  String nameForGame = 'topLeftVillage';

  @override
  String source = 'top_left_village.tmx';//'topLeftVillage';

  @override
  GameConsts gameConsts = GameConsts(maxColumn: 10, maxRow:11);
}


