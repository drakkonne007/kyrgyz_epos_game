import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item getArmor(int id)
{
  switch(id) {
    case 1:
      return Armor1();
    case 2:
      return Armor2();
    case 3:
      return Armor3();
    case 4:
      return Armor4();
    case 5:
      return Armor5();
    case 6:
      return Armor6();
    case 7:
      return Armor7();
    case 8:
      return Armor8();
    case 9:
      return Armor9();
    case 10:
      return Armor10();
    case 11:
      return Armor11();
    case 12:
      return Armor12();
    case 13:
      return Armor13();
    case 14:
      return Armor14();
    case 15:
      return Armor15();
    case 16:
      return Armor16();
    case 17:
      return Armor17();
    case 18:
      return Armor18();
    case 19:
      return Armor19();
    case 20:
      return Armor20();
    case 21:
      return Armor21();
    case 22:
      return Armor22();
    case 23:
      return Armor23();
    case 24:
      return Armor24();
    case 25:
      return Armor25();
    case 26:
      return Armor26();
    case 27:
      return Armor27();
    case 28:
      return Armor28();
    case 29:
      return Armor29();
    case 30:
      return Armor30();
    case 31:
      return Armor31();
    case 32:
      return Armor32();
    case 33:
      return Armor33();
    case 34:
      return Armor34();
    case 35:
      return Armor35();
    case 36:
      return Armor36();
    case 37:
      return Armor37();
    case 38:
      return Armor38();
    case 39:
      return Armor39();
    case 40:
      return Armor40();
    case 41:
      return Armor41();
    case 42:
      return Armor42();
    case 43:
      return Armor43();
    case 44:
      return Armor44();
    case 45:
      return Armor45();
    case 46:
      return Armor46();
    case 47:
      return Armor47();
    case 48:
      return Armor48();
    case 49:
      return Armor49();
    case 50:
      return Armor50();
    default: throw 'Armor not found: $id';
  }
}

class Armor1 extends Item
{
  Armor1()
  {
    id = 'armor1';
    source = 'images/inventar/armor/1.png';
    dressType = DressType.armor;
    cost = 10;
    armor = 1;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor2 extends Item
{
  Armor2()
  {
    id = 'armor2';
    source = 'images/inventar/armor/2.png';
    dressType = DressType.armor;
    cost = 20;
    armor = 2;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor3 extends Item
{
  Armor3()
  {
    id = 'armor1';
    source = 'images/inventar/armor/3.png';
    dressType = DressType.armor;
    cost = 30;
    armor = 3;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor4 extends Item
{
  Armor4()
  {
    id = 'armor4';
    source = 'images/inventar/armor/4.png';
    dressType = DressType.armor;
    cost = 40;
    armor = 4;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor5 extends Item
{
  Armor5()
  {
    id = 'armor5';
    source = 'images/inventar/armor/5.png';
    dressType = DressType.armor;
    cost = 50;
    armor = 5;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor6 extends Item
{
  Armor6()
  {
    id = 'armor6';
    source = 'images/inventar/armor/6.png';
    dressType = DressType.armor;
    cost = 60;
    armor = 6;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor7 extends Item
{
  Armor7()
  {
    id = 'armor7';
    source = 'images/inventar/armor/7.png';
    dressType = DressType.armor;
    cost = 70;
    armor = 7;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor8 extends Item
{
  Armor8()
  {
    id = 'armor8';
    source = 'images/inventar/armor/8.png';
    dressType = DressType.armor;
    cost = 80;
    armor = 8;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor9 extends Item
{
  Armor9()
  {
    id = 'armor9';
    source = 'images/inventar/armor/9.png';
    dressType = DressType.armor;
    cost = 90;
    armor = 9;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor10 extends Item
{
  Armor10()
  {
    id = 'armor10';
    source = 'images/inventar/armor/10.png';
    dressType = DressType.armor;
    cost = 100;
    armor = 10;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor11 extends Item
{
  Armor11()
  {
    id = 'armor11';
    source = 'images/inventar/armor/11.png';
    dressType = DressType.armor;
    cost = 110;
    armor = 11;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor12 extends Item
{
  Armor12()
  {
    id = 'armor12';
    source = 'images/inventar/armor/12.png';
    dressType = DressType.armor;
    cost = 120;
    armor = 12;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor13 extends Item
{
  Armor13()
  {
    id = 'armor31';
    source = 'images/inventar/armor/13.png';
    dressType = DressType.armor;
    cost = 130;
    armor = 13;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor14 extends Item
{
  Armor14()
  {
    id = 'armor14';
    source = 'images/inventar/armor/14.png';
    dressType = DressType.armor;
    cost = 140;
    armor = 14;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor15 extends Item
{
  Armor15()
  {
    id = 'armor15';
    source = 'images/inventar/armor/15.png';
    dressType = DressType.armor;
    cost = 150;
    armor = 15;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor16 extends Item
{
  Armor16()
  {
    id = 'armor16';
    source = 'images/inventar/armor/16.png';
    dressType = DressType.armor;
    cost = 160;
    armor = 16;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor17 extends Item
{
  Armor17()
  {
    id = 'armor17';
    source = 'images/inventar/armor/17.png';
    dressType = DressType.armor;
    cost = 170;
    armor = 17;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor18 extends Item
{
  Armor18()
  {
    id = 'armor18';
    source = 'images/inventar/armor/18.png';
    dressType = DressType.armor;
    cost = 180;
    armor = 18;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor19 extends Item
{
  Armor19()
  {
    id = 'armor19';
    source = 'images/inventar/armor/19.png';
    dressType = DressType.armor;
    cost = 190;
    armor = 19;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor20 extends Item
{
  Armor20()
  {
    id = 'armor20';
    source = 'images/inventar/armor/20.png';
    dressType = DressType.armor;
    cost = 200;
    armor = 20;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor21 extends Item
{
  Armor21()
  {
    id = 'armor21';
    source = 'images/inventar/armor/21.png';
    dressType = DressType.armor;
    cost = 210;
    armor = 21;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor22 extends Item
{
  Armor22()
  {
    id = 'armor22';
    source = 'images/inventar/armor/22.png';
    dressType = DressType.armor;
    cost = 220;
    armor = 22;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor23 extends Item
{
  Armor23()
  {
    id = 'armor23';
    source = 'images/inventar/armor/23.png';
    dressType = DressType.armor;
    cost = 230;
    armor = 23;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor24 extends Item
{
  Armor24()
  {
    id = 'armor24';
    source = 'images/inventar/armor/24.png';
    dressType = DressType.armor;
    cost = 240;
    armor = 24;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor25 extends Item
{
  Armor25()
  {
    id = 'armor25';
    source = 'images/inventar/armor/25.png';
    dressType = DressType.armor;
    cost = 250;
    armor = 25;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor26 extends Item
{
  Armor26()
  {
    id = 'armor26';
    source = 'images/inventar/armor/26.png';
    dressType = DressType.armor;
    cost = 260;
    armor = 26;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor27 extends Item
{
  Armor27()
  {
    id = 'armor27';
    source = 'images/inventar/armor/27.png';
    dressType = DressType.armor;
    cost = 270;
    armor = 27;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor28 extends Item
{
  Armor28()
  {
    id = 'armor28';
    source = 'images/inventar/armor/28.png';
    dressType = DressType.armor;
    cost = 280;
    armor = 28;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor29 extends Item
{
  Armor29()
  {
    id = 'armor29';
    source = 'images/inventar/armor/29.png';
    dressType = DressType.armor;
    cost = 290;
    armor = 29;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor30 extends Item
{
  Armor30()
  {
    id = 'armor30';
    source = 'images/inventar/armor/30.png';
    dressType = DressType.armor;
    cost = 300;
    armor = 30;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor31 extends Item
{
  Armor31()
  {
    id = 'armor31';
    source = 'images/inventar/armor/31.png';
    dressType = DressType.armor;
    cost = 310;
    armor = 31;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor32 extends Item
{
  Armor32()
  {
    id = 'armor32';
    source = 'images/inventar/armor/32.png';
    dressType = DressType.armor;
    cost = 320;
    armor = 32;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor33 extends Item
{
  Armor33()
  {
    id = 'armor33';
    source = 'images/inventar/armor/33.png';
    dressType = DressType.armor;
    cost = 330;
    armor = 33;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor34 extends Item
{
  Armor34()
  {
    id = 'armor34';
    source = 'images/inventar/armor/34.png';
    dressType = DressType.armor;
    cost = 340;
    armor = 34;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor35 extends Item
{
  Armor35()
  {
    id = 'armor35';
    source = 'images/inventar/armor/35.png';
    dressType = DressType.armor;
    cost = 350;
    armor = 35;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor36 extends Item
{
  Armor36()
  {
    id = 'armor36';
    source = 'images/inventar/armor/36.png';
    dressType = DressType.armor;
    cost = 360;
    armor = 36;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor37 extends Item
{
  Armor37()
  {
    id = 'armor37';
    source = 'images/inventar/armor/37.png';
    dressType = DressType.armor;
    cost = 370;
    armor = 37;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor38 extends Item
{
  Armor38()
  {
    id = 'armor38';
    source = 'images/inventar/armor/38.png';
    dressType = DressType.armor;
    cost = 380;
    armor = 38;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor39 extends Item
{
  Armor39()
  {
    id = 'armor39';
    source = 'images/inventar/armor/39.png';
    dressType = DressType.armor;
    cost = 390;
    armor = 39;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor40 extends Item
{
  Armor40()
  {
    id = 'armor40';
    source = 'images/inventar/armor/40.png';
    dressType = DressType.armor;
    cost = 400;
    armor = 40;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor41 extends Item
{
  Armor41()
  {
    id = 'armor41';
    source = 'images/inventar/armor/41.png';
    dressType = DressType.armor;
    cost = 410;
    armor = 41;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor42 extends Item
{
  Armor42()
  {
    id = 'armor42';
    source = 'images/inventar/armor/42.png';
    dressType = DressType.armor;
    cost = 420;
    armor = 42;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor43 extends Item
{
  Armor43()
  {
    id = 'armor1';
    source = 'images/inventar/armor/1.png';
    dressType = DressType.armor;
    cost = 430;
    armor = 43;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor44 extends Item
{
  Armor44()
  {
    id = 'armor44';
    source = 'images/inventar/armor/44.png';
    dressType = DressType.armor;
    cost = 440;
    armor = 44;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor45 extends Item
{
  Armor45()
  {
    id = 'armor45';
    source = 'images/inventar/armor/45.png';
    dressType = DressType.armor;
    cost = 450;
    armor = 45;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor46 extends Item
{
  Armor46()
  {
    id = 'armor46';
    source = 'images/inventar/armor/46.png';
    dressType = DressType.armor;
    cost = 460;
    armor = 46;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor47 extends Item
{
  Armor74()
  {
    id = 'armor74';
    source = 'images/inventar/armor/74.png';
    dressType = DressType.armor;
    cost = 470;
    armor = 47;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor48 extends Item
{
  Armor48()
  {
    id = 'armor48';
    source = 'images/inventar/armor/48.png';
    dressType = DressType.armor;
    cost = 480;
    armor = 48;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor49 extends Item
{
  Armor49()
  {
    id = 'armor49';
    source = 'images/inventar/armor/49.png';
    dressType = DressType.armor;
    cost = 490;
    armor = 49;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Armor50 extends Item
{
  Armor50()
  {
    id = 'armor50';
    source = 'images/inventar/armor/50.png';
    dressType = DressType.armor;
    cost = 500;
    armor = 50;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.bodyArmor, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}