import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item getHelmet(int id)
{
  switch(id) {
    case 1:
      return Helmet1();
    case 2:
      return Helmet2();
    case 3:
      return Helmet3();
    case 4:
      return Helmet4();
    case 5:
      return Helmet5();
    case 6:
      return Helmet6();
    case 7:
      return Helmet7();
    case 8:
      return Helmet8();
    case 9:
      return Helmet9();
    case 10:
      return Helmet10();
    case 11:
      return Helmet11();
    case 12:
      return Helmet12();
    case 13:
      return Helmet13();
    case 14:
      return Helmet14();
    case 15:
      return Helmet15();
    case 16:
      return Helmet16();
    case 17:
      return Helmet17();
    case 18:
      return Helmet18();
    case 19:
      return Helmet19();
    case 20:
      return Helmet20();
    case 21:
      return Helmet21();
    case 22:
      return Helmet22();
    case 23:
      return Helmet23();
    case 24:
      return Helmet24();
    case 25:
      return Helmet25();
    case 26:
      return Helmet26();
    case 27:
      return Helmet27();
    case 28:
      return Helmet28();
    case 29:
      return Helmet29();
    case 30:
      return Helmet30();
    case 31:
      return Helmet31();
    case 32:
      return Helmet32();
    case 33:
      return Helmet33();
    case 34:
      return Helmet34();
    case 35:
      return Helmet35();
    case 36:
      return Helmet36();
    case 37:
      return Helmet37();
    case 38:
      return Helmet38();
    case 39:
      return Helmet39();
    case 40:
      return Helmet40();
    case 41:
      return Helmet41();
    case 42:
      return Helmet42();
    case 43:
      return Helmet43();
    case 44:
      return Helmet44();
    case 45:
      return Helmet45();
    case 46:
      return Helmet46();
    case 47:
      return Helmet47();
    case 48:
      return Helmet48();
    case 49:
      return Helmet49();
    case 50:
      return Helmet50();
    default:
      throw 'Unknown Helmet id $id';
  }
}

class Helmet1 extends Item
{
  Helmet1()
  {
    id = 'helmet1';
    source = 'images/inventar/helmet/1.png';
    dressType = DressType.helmet;
    cost = 10;
    armor = 1;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet2 extends Item
{
  Helmet2()
  {
    id = 'helmet2';
    source = 'images/inventar/helmet/2.png';
    dressType = DressType.helmet;
    cost = 20;
    armor = 2;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet3 extends Item
{
  Helmet3()
  {
    id = 'helmet1';
    source = 'images/inventar/helmet/3.png';
    dressType = DressType.helmet;
    cost = 30;
    armor = 3;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet4 extends Item
{
  Helmet4()
  {
    id = 'helmet4';
    source = 'images/inventar/helmet/4.png';
    dressType = DressType.helmet;
    cost = 40;
    armor = 4;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet5 extends Item
{
  Helmet5()
  {
    id = 'helmet5';
    source = 'images/inventar/helmet/5.png';
    dressType = DressType.helmet;
    cost = 50;
    armor = 5;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet6 extends Item
{
  Helmet6()
  {
    id = 'helmet6';
    source = 'images/inventar/helmet/6.png';
    dressType = DressType.helmet;
    cost = 60;
    armor = 6;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet7 extends Item
{
  Helmet7()
  {
    id = 'helmet7';
    source = 'images/inventar/helmet/7.png';
    dressType = DressType.helmet;
    cost = 70;
    armor = 7;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet8 extends Item
{
  Helmet8()
  {
    id = 'helmet8';
    source = 'images/inventar/helmet/8.png';
    dressType = DressType.helmet;
    cost = 80;
    armor = 8;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet9 extends Item
{
  Helmet9()
  {
    id = 'helmet9';
    source = 'images/inventar/helmet/9.png';
    dressType = DressType.helmet;
    cost = 90;
    armor = 9;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet10 extends Item
{
  Helmet10()
  {
    id = 'helmet10';
    source = 'images/inventar/helmet/10.png';
    dressType = DressType.helmet;
    cost = 100;
    armor = 10;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet11 extends Item
{
  Helmet11()
  {
    id = 'helmet11';
    source = 'images/inventar/helmet/11.png';
    dressType = DressType.helmet;
    cost = 110;
    armor = 11;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet12 extends Item
{
  Helmet12()
  {
    id = 'helmet12';
    source = 'images/inventar/helmet/12.png';
    dressType = DressType.helmet;
    cost = 120;
    armor = 12;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet13 extends Item
{
  Helmet13()
  {
    id = 'helmet31';
    source = 'images/inventar/helmet/13.png';
    dressType = DressType.helmet;
    cost = 130;
    armor = 13;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet14 extends Item
{
  Helmet14()
  {
    id = 'helmet14';
    source = 'images/inventar/helmet/14.png';
    dressType = DressType.helmet;
    cost = 140;
    armor = 14;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet15 extends Item
{
  Helmet15()
  {
    id = 'helmet15';
    source = 'images/inventar/helmet/15.png';
    dressType = DressType.helmet;
    cost = 150;
    armor = 15;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet16 extends Item
{
  Helmet16()
  {
    id = 'helmet16';
    source = 'images/inventar/helmet/16.png';
    dressType = DressType.helmet;
    cost = 160;
    armor = 16;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet17 extends Item
{
  Helmet17()
  {
    id = 'helmet17';
    source = 'images/inventar/helmet/17.png';
    dressType = DressType.helmet;
    cost = 170;
    armor = 17;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet18 extends Item
{
  Helmet18()
  {
    id = 'helmet18';
    source = 'images/inventar/helmet/18.png';
    dressType = DressType.helmet;
    cost = 180;
    armor = 18;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet19 extends Item
{
  Helmet19()
  {
    id = 'helmet19';
    source = 'images/inventar/helmet/19.png';
    dressType = DressType.helmet;
    cost = 190;
    armor = 19;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet20 extends Item
{
  Helmet20()
  {
    id = 'helmet20';
    source = 'images/inventar/helmet/20.png';
    dressType = DressType.helmet;
    cost = 200;
    armor = 20;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet21 extends Item
{
  Helmet21()
  {
    id = 'helmet21';
    source = 'images/inventar/helmet/21.png';
    dressType = DressType.helmet;
    cost = 210;
    armor = 21;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet22 extends Item
{
  Helmet22()
  {
    id = 'helmet22';
    source = 'images/inventar/helmet/22.png';
    dressType = DressType.helmet;
    cost = 220;
    armor = 22;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet23 extends Item
{
  Helmet23()
  {
    id = 'helmet23';
    source = 'images/inventar/helmet/23.png';
    dressType = DressType.helmet;
    cost = 230;
    armor = 23;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet24 extends Item
{
  Helmet24()
  {
    id = 'helmet24';
    source = 'images/inventar/helmet/24.png';
    dressType = DressType.helmet;
    cost = 240;
    armor = 24;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet25 extends Item
{
  Helmet25()
  {
    id = 'helmet25';
    source = 'images/inventar/helmet/25.png';
    dressType = DressType.helmet;
    cost = 250;
    armor = 25;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet26 extends Item
{
  Helmet26()
  {
    id = 'helmet26';
    source = 'images/inventar/helmet/26.png';
    dressType = DressType.helmet;
    cost = 260;
    armor = 26;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet27 extends Item
{
  Helmet27()
  {
    id = 'helmet27';
    source = 'images/inventar/helmet/27.png';
    dressType = DressType.helmet;
    cost = 270;
    armor = 27;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet28 extends Item
{
  Helmet28()
  {
    id = 'helmet28';
    source = 'images/inventar/helmet/28.png';
    dressType = DressType.helmet;
    cost = 280;
    armor = 28;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet29 extends Item
{
  Helmet29()
  {
    id = 'helmet29';
    source = 'images/inventar/helmet/29.png';
    dressType = DressType.helmet;
    cost = 290;
    armor = 29;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet30 extends Item
{
  Helmet30()
  {
    id = 'helmet30';
    source = 'images/inventar/helmet/30.png';
    dressType = DressType.helmet;
    cost = 300;
    armor = 30;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet31 extends Item
{
  Helmet31()
  {
    id = 'helmet31';
    source = 'images/inventar/helmet/31.png';
    dressType = DressType.helmet;
    cost = 310;
    armor = 31;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet32 extends Item
{
  Helmet32()
  {
    id = 'helmet32';
    source = 'images/inventar/helmet/32.png';
    dressType = DressType.helmet;
    cost = 320;
    armor = 32;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet33 extends Item
{
  Helmet33()
  {
    id = 'helmet33';
    source = 'images/inventar/helmet/33.png';
    dressType = DressType.helmet;
    cost = 330;
    armor = 33;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet34 extends Item
{
  Helmet34()
  {
    id = 'helmet34';
    source = 'images/inventar/helmet/34.png';
    dressType = DressType.helmet;
    cost = 340;
    armor = 34;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet35 extends Item
{
  Helmet35()
  {
    id = 'helmet35';
    source = 'images/inventar/helmet/35.png';
    dressType = DressType.helmet;
    cost = 350;
    armor = 35;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet36 extends Item
{
  Helmet36()
  {
    id = 'helmet36';
    source = 'images/inventar/helmet/36.png';
    dressType = DressType.helmet;
    cost = 360;
    armor = 36;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet37 extends Item
{
  Helmet37()
  {
    id = 'helmet37';
    source = 'images/inventar/helmet/37.png';
    dressType = DressType.helmet;
    cost = 370;
    armor = 37;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet38 extends Item
{
  Helmet38()
  {
    id = 'helmet38';
    source = 'images/inventar/helmet/38.png';
    dressType = DressType.helmet;
    cost = 380;
    armor = 38;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet39 extends Item
{
  Helmet39()
  {
    id = 'helmet39';
    source = 'images/inventar/helmet/39.png';
    dressType = DressType.helmet;
    cost = 390;
    armor = 39;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet40 extends Item
{
  Helmet40()
  {
    id = 'helmet40';
    source = 'images/inventar/helmet/40.png';
    dressType = DressType.helmet;
    cost = 400;
    armor = 40;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet41 extends Item
{
  Helmet41()
  {
    id = 'helmet41';
    source = 'images/inventar/helmet/41.png';
    dressType = DressType.helmet;
    cost = 410;
    armor = 41;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet42 extends Item
{
  Helmet42()
  {
    id = 'helmet42';
    source = 'images/inventar/helmet/42.png';
    dressType = DressType.helmet;
    cost = 420;
    armor = 42;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet43 extends Item
{
  Helmet43()
  {
    id = 'helmet1';
    source = 'images/inventar/helmet/1.png';
    dressType = DressType.helmet;
    cost = 430;
    armor = 43;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet44 extends Item
{
  Helmet44()
  {
    id = 'helmet44';
    source = 'images/inventar/helmet/44.png';
    dressType = DressType.helmet;
    cost = 440;
    armor = 44;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet45 extends Item
{
  Helmet45()
  {
    id = 'helmet45';
    source = 'images/inventar/helmet/45.png';
    dressType = DressType.helmet;
    cost = 450;
    armor = 45;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet46 extends Item
{
  Helmet46()
  {
    id = 'helmet46';
    source = 'images/inventar/helmet/46.png';
    dressType = DressType.helmet;
    cost = 460;
    armor = 46;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet47 extends Item
{
  Helmet74()
  {
    id = 'helmet74';
    source = 'images/inventar/helmet/74.png';
    dressType = DressType.helmet;
    cost = 470;
    armor = 47;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet48 extends Item
{
  Helmet48()
  {
    id = 'helmet48';
    source = 'images/inventar/helmet/48.png';
    dressType = DressType.helmet;
    cost = 480;
    armor = 48;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet49 extends Item
{
  Helmet49()
  {
    id = 'helmet49';
    source = 'images/inventar/helmet/49.png';
    dressType = DressType.helmet;
    cost = 490;
    armor = 49;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Helmet50 extends Item
{
  Helmet50()
  {
    id = 'helmet50';
    source = 'images/inventar/helmet/50.png';
    dressType = DressType.helmet;
    cost = 500;
    armor = 50;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.helmet, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}