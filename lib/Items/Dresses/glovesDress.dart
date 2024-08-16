import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item getGloves(int id)
{
  switch(id) {
    case 1:
      return Gloves1();
    case 2:
      return Gloves2();
    case 3:
      return Gloves3();
    case 4:
      return Gloves4();
    case 5:
      return Gloves5();
    case 6:
      return Gloves6();
    case 7:
      return Gloves7();
    case 8:
      return Gloves8();
    case 9:
      return Gloves9();
    case 10:
      return Gloves10();
    case 11:
      return Gloves11();
    case 12:
      return Gloves12();
    case 13:
      return Gloves13();
    case 14:
      return Gloves14();
    case 15:
      return Gloves15();
    case 16:
      return Gloves16();
    case 17:
      return Gloves17();
    case 18:
      return Gloves18();
    case 19:
      return Gloves19();
    case 20:
      return Gloves20();
    case 21:
      return Gloves21();
    case 22:
      return Gloves22();
    case 23:
      return Gloves23();
    case 24:
      return Gloves24();
    case 25:
      return Gloves25();
    case 26:
      return Gloves26();
    case 27:
      return Gloves27();
    case 28:
      return Gloves28();
    case 29:
      return Gloves29();
    case 30:
      return Gloves30();
    case 31:
      return Gloves31();
    case 32:
      return Gloves32();
    case 33:
      return Gloves33();
    case 34:
      return Gloves34();
    case 35:
      return Gloves35();
    case 36:
      return Gloves36();
    case 37:
      return Gloves37();
    case 38:
      return Gloves38();
    case 39:
      return Gloves39();
    case 40:
      return Gloves40();
    case 41:
      return Gloves41();
    case 42:
      return Gloves42();
    case 43:
      return Gloves43();
    case 44:
      return Gloves44();
    case 45:
      return Gloves45();
    case 46:
      return Gloves46();
    case 47:
      return Gloves47();
    case 48:
      return Gloves48();
    case 49:
      return Gloves49();
    case 50:
      return Gloves50();
    default:
      throw 'no item with id $id';
  }
}

class Gloves1 extends Item
{
  Gloves1()
  {
    id = 'gloves1';
    source = 'images/inventar/gloves/1.png';
    dressType = DressType.gloves;
    cost = 10;
    armor = 1;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves2 extends Item
{
  Gloves2()
  {
    id = 'gloves2';
    source = 'images/inventar/gloves/2.png';
    dressType = DressType.gloves;
    cost = 20;
    armor = 2;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves3 extends Item
{
  Gloves3()
  {
    id = 'gloves1';
    source = 'images/inventar/gloves/3.png';
    dressType = DressType.gloves;
    cost = 30;
    armor = 3;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves4 extends Item
{
  Gloves4()
  {
    id = 'gloves4';
    source = 'images/inventar/gloves/4.png';
    dressType = DressType.gloves;
    cost = 40;
    armor = 4;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves5 extends Item
{
  Gloves5()
  {
    id = 'gloves5';
    source = 'images/inventar/gloves/5.png';
    dressType = DressType.gloves;
    cost = 50;
    armor = 5;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves6 extends Item
{
  Gloves6()
  {
    id = 'gloves6';
    source = 'images/inventar/gloves/6.png';
    dressType = DressType.gloves;
    cost = 60;
    armor = 6;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves7 extends Item
{
  Gloves7()
  {
    id = 'gloves7';
    source = 'images/inventar/gloves/7.png';
    dressType = DressType.gloves;
    cost = 70;
    armor = 7;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves8 extends Item
{
  Gloves8()
  {
    id = 'gloves8';
    source = 'images/inventar/gloves/8.png';
    dressType = DressType.gloves;
    cost = 80;
    armor = 8;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves9 extends Item
{
  Gloves9()
  {
    id = 'gloves9';
    source = 'images/inventar/gloves/9.png';
    dressType = DressType.gloves;
    cost = 90;
    armor = 9;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves10 extends Item
{
  Gloves10()
  {
    id = 'gloves10';
    source = 'images/inventar/gloves/10.png';
    dressType = DressType.gloves;
    cost = 100;
    armor = 10;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves11 extends Item
{
  Gloves11()
  {
    id = 'gloves11';
    source = 'images/inventar/gloves/11.png';
    dressType = DressType.gloves;
    cost = 110;
    armor = 11;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves12 extends Item
{
  Gloves12()
  {
    id = 'gloves12';
    source = 'images/inventar/gloves/12.png';
    dressType = DressType.gloves;
    cost = 120;
    armor = 12;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves13 extends Item
{
  Gloves13()
  {
    id = 'gloves31';
    source = 'images/inventar/gloves/13.png';
    dressType = DressType.gloves;
    cost = 130;
    armor = 13;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves14 extends Item
{
  Gloves14()
  {
    id = 'gloves14';
    source = 'images/inventar/gloves/14.png';
    dressType = DressType.gloves;
    cost = 140;
    armor = 14;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves15 extends Item
{
  Gloves15()
  {
    id = 'gloves15';
    source = 'images/inventar/gloves/15.png';
    dressType = DressType.gloves;
    cost = 150;
    armor = 15;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves16 extends Item
{
  Gloves16()
  {
    id = 'gloves16';
    source = 'images/inventar/gloves/16.png';
    dressType = DressType.gloves;
    cost = 160;
    armor = 16;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves17 extends Item
{
  Gloves17()
  {
    id = 'gloves17';
    source = 'images/inventar/gloves/17.png';
    dressType = DressType.gloves;
    cost = 170;
    armor = 17;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves18 extends Item
{
  Gloves18()
  {
    id = 'gloves18';
    source = 'images/inventar/gloves/18.png';
    dressType = DressType.gloves;
    cost = 180;
    armor = 18;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves19 extends Item
{
  Gloves19()
  {
    id = 'gloves19';
    source = 'images/inventar/gloves/19.png';
    dressType = DressType.gloves;
    cost = 190;
    armor = 19;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves20 extends Item
{
  Gloves20()
  {
    id = 'gloves20';
    source = 'images/inventar/gloves/20.png';
    dressType = DressType.gloves;
    cost = 200;
    armor = 20;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves21 extends Item
{
  Gloves21()
  {
    id = 'gloves21';
    source = 'images/inventar/gloves/21.png';
    dressType = DressType.gloves;
    cost = 210;
    armor = 21;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves22 extends Item
{
  Gloves22()
  {
    id = 'gloves22';
    source = 'images/inventar/gloves/22.png';
    dressType = DressType.gloves;
    cost = 220;
    armor = 22;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves23 extends Item
{
  Gloves23()
  {
    id = 'gloves23';
    source = 'images/inventar/gloves/23.png';
    dressType = DressType.gloves;
    cost = 230;
    armor = 23;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves24 extends Item
{
  Gloves24()
  {
    id = 'gloves24';
    source = 'images/inventar/gloves/24.png';
    dressType = DressType.gloves;
    cost = 240;
    armor = 24;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves25 extends Item
{
  Gloves25()
  {
    id = 'gloves25';
    source = 'images/inventar/gloves/25.png';
    dressType = DressType.gloves;
    cost = 250;
    armor = 25;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves26 extends Item
{
  Gloves26()
  {
    id = 'gloves26';
    source = 'images/inventar/gloves/26.png';
    dressType = DressType.gloves;
    cost = 260;
    armor = 26;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves27 extends Item
{
  Gloves27()
  {
    id = 'gloves27';
    source = 'images/inventar/gloves/27.png';
    dressType = DressType.gloves;
    cost = 270;
    armor = 27;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves28 extends Item
{
  Gloves28()
  {
    id = 'gloves28';
    source = 'images/inventar/gloves/28.png';
    dressType = DressType.gloves;
    cost = 280;
    armor = 28;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves29 extends Item
{
  Gloves29()
  {
    id = 'gloves29';
    source = 'images/inventar/gloves/29.png';
    dressType = DressType.gloves;
    cost = 290;
    armor = 29;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves30 extends Item
{
  Gloves30()
  {
    id = 'gloves30';
    source = 'images/inventar/gloves/30.png';
    dressType = DressType.gloves;
    cost = 300;
    armor = 30;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves31 extends Item
{
  Gloves31()
  {
    id = 'gloves31';
    source = 'images/inventar/gloves/31.png';
    dressType = DressType.gloves;
    cost = 310;
    armor = 31;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves32 extends Item
{
  Gloves32()
  {
    id = 'gloves32';
    source = 'images/inventar/gloves/32.png';
    dressType = DressType.gloves;
    cost = 320;
    armor = 32;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves33 extends Item
{
  Gloves33()
  {
    id = 'gloves33';
    source = 'images/inventar/gloves/33.png';
    dressType = DressType.gloves;
    cost = 330;
    armor = 33;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves34 extends Item
{
  Gloves34()
  {
    id = 'gloves34';
    source = 'images/inventar/gloves/34.png';
    dressType = DressType.gloves;
    cost = 340;
    armor = 34;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves35 extends Item
{
  Gloves35()
  {
    id = 'gloves35';
    source = 'images/inventar/gloves/35.png';
    dressType = DressType.gloves;
    cost = 350;
    armor = 35;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves36 extends Item
{
  Gloves36()
  {
    id = 'gloves36';
    source = 'images/inventar/gloves/36.png';
    dressType = DressType.gloves;
    cost = 360;
    armor = 36;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves37 extends Item
{
  Gloves37()
  {
    id = 'gloves37';
    source = 'images/inventar/gloves/37.png';
    dressType = DressType.gloves;
    cost = 370;
    armor = 37;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves38 extends Item
{
  Gloves38()
  {
    id = 'gloves38';
    source = 'images/inventar/gloves/38.png';
    dressType = DressType.gloves;
    cost = 380;
    armor = 38;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves39 extends Item
{
  Gloves39()
  {
    id = 'gloves39';
    source = 'images/inventar/gloves/39.png';
    dressType = DressType.gloves;
    cost = 390;
    armor = 39;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves40 extends Item
{
  Gloves40()
  {
    id = 'gloves40';
    source = 'images/inventar/gloves/40.png';
    dressType = DressType.gloves;
    cost = 400;
    armor = 40;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves41 extends Item
{
  Gloves41()
  {
    id = 'gloves41';
    source = 'images/inventar/gloves/41.png';
    dressType = DressType.gloves;
    cost = 410;
    armor = 41;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves42 extends Item
{
  Gloves42()
  {
    id = 'gloves42';
    source = 'images/inventar/gloves/42.png';
    dressType = DressType.gloves;
    cost = 420;
    armor = 42;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves43 extends Item
{
  Gloves43()
  {
    id = 'gloves1';
    source = 'images/inventar/gloves/1.png';
    dressType = DressType.gloves;
    cost = 430;
    armor = 43;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves44 extends Item
{
  Gloves44()
  {
    id = 'gloves44';
    source = 'images/inventar/gloves/44.png';
    dressType = DressType.gloves;
    cost = 440;
    armor = 44;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves45 extends Item
{
  Gloves45()
  {
    id = 'gloves45';
    source = 'images/inventar/gloves/45.png';
    dressType = DressType.gloves;
    cost = 450;
    armor = 45;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves46 extends Item
{
  Gloves46()
  {
    id = 'gloves46';
    source = 'images/inventar/gloves/46.png';
    dressType = DressType.gloves;
    cost = 460;
    armor = 46;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves47 extends Item
{
  Gloves74()
  {
    id = 'gloves74';
    source = 'images/inventar/gloves/74.png';
    dressType = DressType.gloves;
    cost = 470;
    armor = 47;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves48 extends Item
{
  Gloves48()
  {
    id = 'gloves48';
    source = 'images/inventar/gloves/48.png';
    dressType = DressType.gloves;
    cost = 480;
    armor = 48;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves49 extends Item
{
  Gloves49()
  {
    id = 'gloves49';
    source = 'images/inventar/gloves/49.png';
    dressType = DressType.gloves;
    cost = 490;
    armor = 49;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Gloves50 extends Item
{
  Gloves50()
  {
    id = 'gloves50';
    source = 'images/inventar/gloves/50.png';
    dressType = DressType.gloves;
    cost = 500;
    armor = 50;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.gloves, id);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}