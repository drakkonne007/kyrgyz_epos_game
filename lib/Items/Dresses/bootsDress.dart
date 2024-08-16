import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item getBoots(int id)
{
  switch(id)
  {
    case 1: return Boots1();
    case 2: return Boots2();
    case 3: return Boots3();
    case 4: return Boots4();
    case 5: return Boots5();
    case 6: return Boots6();
    case 7: return Boots7();
    case 8: return Boots8();
    case 9: return Boots9();
    case 10: return Boots10();
    case 11: return Boots11();
    case 12: return Boots12();
    case 13: return Boots13();
    case 14: return Boots14();
    case 15: return Boots15();
    case 16: return Boots16();
    case 17: return Boots17();
    case 18: return Boots18();
    case 19: return Boots19();
    case 20: return Boots20();
    case 21: return Boots21();
    case 22: return Boots22();
    case 23: return Boots23();
    case 24: return Boots24();
    case 25: return Boots25();
    case 26: return Boots26();
    case 27: return Boots27();
    case 28: return Boots28();
    case 29: return Boots29();
    case 30: return Boots30();
    case 31: return Boots31();
    case 32: return Boots32();
    case 33: return Boots33();
    case 34: return Boots34();
    case 35: return Boots35();
    case 36: return Boots36();
    case 37: return Boots37();
    case 38: return Boots38();
    case 39: return Boots39();
    case 40: return Boots40();
    case 41: return Boots41();
    case 42: return Boots42();
    case 43: return Boots43();
    case 44: return Boots44();
    case 45: return Boots45();
    case 46: return Boots46();
    case 47: return Boots47();
    case 48: return Boots48();
    case 49: return Boots49();
    case 50: return Boots50();
    default: throw 'no boots with id $id';
  }
}

class Boots1 extends Item
{
  Boots1()
  {
    id = 'boots1';
    source = 'images/inventar/boots/1.png';
    dressType = DressType.boots;
    cost = 10;
    armor = 1;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots2 extends Item
{
  Boots2()
  {
    id = 'boots2';
    source = 'images/inventar/boots/2.png';
    dressType = DressType.boots;
    cost = 20;
    armor = 2;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots3 extends Item
{
  Boots3()
  {
    id = 'boots3';
    source = 'images/inventar/boots/3.png';
    dressType = DressType.boots;
    cost = 30;
    armor = 3;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots4 extends Item
{
  Boots4()
  {
    id = 'boots4';
    source = 'images/inventar/boots/4.png';
    dressType = DressType.boots;
    cost = 40;
    armor = 4;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots5 extends Item
{
  Boots5()
  {
    id = 'boots5';
    source = 'images/inventar/boots/5.png';
    dressType = DressType.boots;
    cost = 50;
    armor = 5;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots6 extends Item
{
  Boots6()
  {
    id = 'boots6';
    source = 'images/inventar/boots/6.png';
    dressType = DressType.boots;
    cost = 60;
    armor = 6;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots7 extends Item
{
  Boots7()
  {
    id = 'boots7';
    source = 'images/inventar/boots/7.png';
    dressType = DressType.boots;
    cost = 70;
    armor = 7;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots8 extends Item
{
  Boots8()
  {
    id = 'boots8';
    source = 'images/inventar/boots/8.png';
    dressType = DressType.boots;
    cost = 80;
    armor = 8;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots9 extends Item
{
  Boots9()
  {
    id = 'boots9';
    source = 'images/inventar/boots/9.png';
    dressType = DressType.boots;
    cost = 90;
    armor = 9;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots10 extends Item
{
  Boots10()
  {
    id = 'boots10';
    source = 'images/inventar/boots/10.png';
    dressType = DressType.boots;
    cost = 100;
    armor = 10;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots11 extends Item
{
  Boots11()
  {
    id = 'boots11';
    source = 'images/inventar/boots/11.png';
    dressType = DressType.boots;
    cost = 110;
    armor = 11;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots12 extends Item
{
  Boots12()
  {
    id = 'boots12';
    source = 'images/inventar/boots/12.png';
    dressType = DressType.boots;
    cost = 120;
    armor = 12;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots13 extends Item
{
  Boots13()
  {
    id = 'boots31';
    source = 'images/inventar/boots/13.png';
    dressType = DressType.boots;
    cost = 130;
    armor = 13;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots14 extends Item
{
  Boots14()
  {
    id = 'boots14';
    source = 'images/inventar/boots/14.png';
    dressType = DressType.boots;
    cost = 140;
    armor = 14;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots15 extends Item
{
  Boots15()
  {
    id = 'boots15';
    source = 'images/inventar/boots/15.png';
    dressType = DressType.boots;
    cost = 150;
    armor = 15;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots16 extends Item
{
  Boots16()
  {
    id = 'boots16';
    source = 'images/inventar/boots/16.png';
    dressType = DressType.boots;
    cost = 160;
    armor = 16;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots17 extends Item
{
  Boots17()
  {
    id = 'boots17';
    source = 'images/inventar/boots/17.png';
    dressType = DressType.boots;
    cost = 170;
    armor = 17;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots18 extends Item
{
  Boots18()
  {
    id = 'boots18';
    source = 'images/inventar/boots/18.png';
    dressType = DressType.boots;
    cost = 180;
    armor = 18;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots19 extends Item
{
  Boots19()
  {
    id = 'boots19';
    source = 'images/inventar/boots/19.png';
    dressType = DressType.boots;
    cost = 190;
    armor = 19;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots20 extends Item
{
  Boots20()
  {
    id = 'boots20';
    source = 'images/inventar/boots/20.png';
    dressType = DressType.boots;
    cost = 200;
    armor = 20;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots21 extends Item
{
  Boots21()
  {
    id = 'boots21';
    source = 'images/inventar/boots/21.png';
    dressType = DressType.boots;
    cost = 210;
    armor = 21;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots22 extends Item
{
  Boots22()
  {
    id = 'boots22';
    source = 'images/inventar/boots/22.png';
    dressType = DressType.boots;
    cost = 220;
    armor = 22;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots23 extends Item
{
  Boots23()
  {
    id = 'boots23';
    source = 'images/inventar/boots/23.png';
    dressType = DressType.boots;
    cost = 230;
    armor = 23;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots24 extends Item
{
  Boots24()
  {
    id = 'boots24';
    source = 'images/inventar/boots/24.png';
    dressType = DressType.boots;
    cost = 240;
    armor = 24;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots25 extends Item
{
  Boots25()
  {
    id = 'boots25';
    source = 'images/inventar/boots/25.png';
    dressType = DressType.boots;
    cost = 250;
    armor = 25;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots26 extends Item
{
  Boots26()
  {
    id = 'boots26';
    source = 'images/inventar/boots/26.png';
    dressType = DressType.boots;
    cost = 260;
    armor = 26;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots27 extends Item
{
  Boots27()
  {
    id = 'boots27';
    source = 'images/inventar/boots/27.png';
    dressType = DressType.boots;
    cost = 270;
    armor = 27;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots28 extends Item
{
  Boots28()
  {
    id = 'boots28';
    source = 'images/inventar/boots/28.png';
    dressType = DressType.boots;
    cost = 280;
    armor = 28;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots29 extends Item
{
  Boots29()
  {
    id = 'boots29';
    source = 'images/inventar/boots/29.png';
    dressType = DressType.boots;
    cost = 290;
    armor = 29;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots30 extends Item
{
  Boots30()
  {
    id = 'boots30';
    source = 'images/inventar/boots/30.png';
    dressType = DressType.boots;
    cost = 300;
    armor = 30;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots31 extends Item
{
  Boots31()
  {
    id = 'boots31';
    source = 'images/inventar/boots/31.png';
    dressType = DressType.boots;
    cost = 310;
    armor = 31;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots32 extends Item
{
  Boots32()
  {
    id = 'boots32';
    source = 'images/inventar/boots/32.png';
    dressType = DressType.boots;
    cost = 320;
    armor = 32;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots33 extends Item
{
  Boots33()
  {
    id = 'boots33';
    source = 'images/inventar/boots/33.png';
    dressType = DressType.boots;
    cost = 330;
    armor = 33;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots34 extends Item
{
  Boots34()
  {
    id = 'boots34';
    source = 'images/inventar/boots/34.png';
    dressType = DressType.boots;
    cost = 340;
    armor = 34;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots35 extends Item
{
  Boots35()
  {
    id = 'boots35';
    source = 'images/inventar/boots/35.png';
    dressType = DressType.boots;
    cost = 350;
    armor = 35;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots36 extends Item
{
  Boots36()
  {
    id = 'boots36';
    source = 'images/inventar/boots/36.png';
    dressType = DressType.boots;
    cost = 360;
    armor = 36;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots37 extends Item
{
  Boots37()
  {
    id = 'boots37';
    source = 'images/inventar/boots/37.png';
    dressType = DressType.boots;
    cost = 370;
    armor = 37;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots38 extends Item
{
  Boots38()
  {
    id = 'boots38';
    source = 'images/inventar/boots/38.png';
    dressType = DressType.boots;
    cost = 380;
    armor = 38;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots39 extends Item
{
  Boots39()
  {
    id = 'boots39';
    source = 'images/inventar/boots/39.png';
    dressType = DressType.boots;
    cost = 390;
    armor = 39;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots40 extends Item
{
  Boots40()
  {
    id = 'boots40';
    source = 'images/inventar/boots/40.png';
    dressType = DressType.boots;
    cost = 400;
    armor = 40;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots41 extends Item
{
  Boots41()
  {
    id = 'boots41';
    source = 'images/inventar/boots/41.png';
    dressType = DressType.boots;
    cost = 410;
    armor = 41;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots42 extends Item
{
  Boots42()
  {
    id = 'boots42';
    source = 'images/inventar/boots/42.png';
    dressType = DressType.boots;
    cost = 420;
    armor = 42;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots43 extends Item
{
  Boots43()
  {
    id = 'boots1';
    source = 'images/inventar/boots/1.png';
    dressType = DressType.boots;
    cost = 430;
    armor = 43;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots44 extends Item
{
  Boots44()
  {
    id = 'boots44';
    source = 'images/inventar/boots/44.png';
    dressType = DressType.boots;
    cost = 440;
    armor = 44;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots45 extends Item
{
  Boots45()
  {
    id = 'boots45';
    source = 'images/inventar/boots/45.png';
    dressType = DressType.boots;
    cost = 450;
    armor = 45;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots46 extends Item
{
  Boots46()
  {
    id = 'boots46';
    source = 'images/inventar/boots/46.png';
    dressType = DressType.boots;
    cost = 460;
    armor = 46;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots47 extends Item
{
  Boots74()
  {
    id = 'boots74';
    source = 'images/inventar/boots/74.png';
    dressType = DressType.boots;
    cost = 470;
    armor = 47;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots48 extends Item
{
  Boots48()
  {
    id = 'boots48';
    source = 'images/inventar/boots/48.png';
    dressType = DressType.boots;
    cost = 480;
    armor = 48;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots49 extends Item
{
  Boots49()
  {
    id = 'boots49';
    source = 'images/inventar/boots/49.png';
    dressType = DressType.boots;
    cost = 490;
    armor = 49;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Boots50 extends Item
{
  Boots50()
  {
    id = 'boots50';
    source = 'images/inventar/boots/50.png';
    dressType = DressType.boots;
    cost = 500;
    armor = 50;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.boots, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}