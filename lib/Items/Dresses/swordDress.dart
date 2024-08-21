import 'package:game_flame/Items/Dresses/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

Item getSword(int id)
{
  switch(id) {
    case 1:
      return Sword1();
    case 2:
      return Sword2();
    case 3:
      return Sword3();
    case 4:
      return Sword4();
    case 5:
      return Sword5();
    case 6:
      return Sword6();
    case 7:
      return Sword7();
    case 8:
      return Sword8();
    case 9:
      return Sword9();
    case 10:
      return Sword10();
    case 11:
      return Sword11();
    case 12:
      return Sword12();
    case 13:
      return Sword13();
    case 14:
      return Sword14();
    case 15:
      return Sword15();
    case 16:
      return Sword16();
    case 17:
      return Sword17();
    case 18:
      return Sword18();
    case 19:
      return Sword19();
    case 20:
      return Sword20();
    case 21:
      return Sword21();
    case 22:
      return Sword22();
    case 23:
      return Sword23();
    case 24:
      return Sword24();
    case 25:
      return Sword25();
    case 26:
      return Sword26();
    case 27:
      return Sword27();
    case 28:
      return Sword28();
    case 29:
      return Sword29();
    case 30:
      return Sword30();
    case 31:
      return Sword31();
    case 32:
      return Sword32();
    case 33:
      return Sword33();
    case 34:
      return Sword34();
    case 35:
      return Sword35();
    case 36:
      return Sword36();
    case 37:
      return Sword37();
    case 38:
      return Sword38();
    case 39:
      return Sword39();
    case 40:
      return Sword40();
    case 41:
      return Sword41();
    case 42:
      return Sword42();
    case 43:
      return Sword43();
    case 44:
      return Sword44();
    case 45:
      return Sword45();
    case 46:
      return Sword46();
    case 47:
      return Sword47();
    case 48:
      return Sword48();
    case 49:
      return Sword49();
    default: throw 'Sword not found: $id';
  }
}

class Sword1 extends Item
{
    Sword1()
  {
    id = 'sword1';
    source = 'images/inventar/weapon/1.png';
    cost = 50;
    damage = 1;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword2 extends Item
{
  Sword2()
  {
    id = 'sword2';
    source = 'images/inventar/weapon/2.png';
    cost = 50;
    attackSpeed = -0.002;
    damage = 1;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword3 extends Item
{
  Sword3()
  {
    id = 'sword3';
    source = 'images/inventar/weapon/3.png';
    cost = 50;
    damage = 1.2;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword4 extends Item
{
  Sword4()
  {
    id = 'sword4';
    source = 'images/inventar/weapon/4.png';
    cost = 50;
    damage = 0.8;
    attackSpeed = - 0.005;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword5 extends Item {
  Sword5() {
    id = 'sword5';
    source = 'images/inventar/weapon/5.png';
    cost = 50;
    damage = 1.2;
    attackSpeed = -0.004;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword6 extends Item {
  Sword6() {
    id = 'sword6';
    source = 'images/inventar/weapon/6.png';
    cost = 75;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword7 extends Item {
  Sword7() {
    id = 'sword7';
    source = 'images/inventar/weapon/7.png';
    cost = 75;
    damage = 1.7;
    attackSpeed = 0.003;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword8 extends Item {
  Sword8() {
    id = 'sword8';
    source = 'images/inventar/weapon/8.png';
    cost = 75;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword9 extends Item {
  Sword9() {
    id = 'sword9';
    source = 'images/inventar/weapon/9.png';
    cost = 75;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword10 extends Item {
  Sword10() {
    id = 'sword10';
    source = 'images/inventar/weapon/10.png';
    cost = 75;
    damage = 1.8;
    attackSpeed = 0.006;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword11 extends Item {
  Sword11() {
    id = 'sword11';
    source = 'images/inventar/weapon/11.png';
    cost = 75;
    damage = 1.5;
    attackSpeed = -0.005;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword12 extends Item {
  Sword12() {
    id = 'sword12';
    source = 'images/inventar/weapon/12.png';
    cost = 80;
    damage = 1.4;
    attackSpeed = -0.008;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword13 extends Item {
  Sword13() {
    id = 'sword13';
    source = 'images/inventar/weapon/13.png';
    cost = 80;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword14 extends Item {
  Sword14() {
    id = 'sword14';
    source = 'images/inventar/weapon/14.png';
    cost = 80;
    damage = 1.6;
    attackSpeed = -0.009;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword15 extends Item {
  Sword15() {
    id = 'sword15';
    source = 'images/inventar/weapon/15.png';
    cost = 80;
    damage = 1.75;
    attackSpeed = -0.009;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword16 extends Item {
  Sword16() {
    id = 'sword16';
    source = 'images/inventar/weapon/16.png';
    cost = 80;
    damage = 1.5;
    attackSpeed = -0.011;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword17 extends Item {
  Sword17() {
    id = 'sword17';
    source = 'images/inventar/weapon/17.png';
    cost = 85;
    damage = 1.6;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword18 extends Item {
  Sword18() {
    id = 'sword18';
    source = 'images/inventar/weapon/18.png';
    cost = 100;
    damage = 1.6;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
    permanentDamage = 0.2;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword19 extends Item {
  Sword19() {
    id = 'sword19';
    source = 'images/inventar/weapon/19.png';
    cost = 100;
    damage = 1.6;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
    permanentDamage = 0.2;
    secsOfPermDamage = 3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword20 extends Item {
  Sword20() {
    id = 'sword20';
    source = 'images/inventar/weapon/20.png';
    cost = 12;
    damage = 1.8;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword21 extends Item {
  Sword21() {
    id = 'sword21';
    source = 'images/inventar/weapon/21.png';
    cost = 12;
    damage = 1.8;
    dressType = DressType.sword;
    attackSpeed = -0.008;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword22 extends Item {
  Sword22() {
    id = 'sword22';
    source = 'images/inventar/weapon/22.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    attackSpeed = -0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword23 extends Item {
  Sword23() {
    id = 'sword23';
    source = 'images/inventar/weapon/23.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    attackSpeed = -0.01;
    magicDamage = MagicDamage.ice;
    manaCost = 10;
    permanentDamage = 0.4;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword24 extends Item {
  Sword24() {
    id = 'sword24';
    source = 'images/inventar/weapon/24.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
    permanentDamage = 0.6;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword25 extends Item {
  Sword25() {
    id = 'sword25';
    source = 'images/inventar/weapon/25.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
    permanentDamage = 0.6;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword26 extends Item {
  Sword26() {
    id = 'sword26';
    source = 'images/inventar/weapon/26.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    manaCost = 10;
    permanentDamage = 0.6;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword27 extends Item {
  Sword27() {
    id = 'sword27';
    source = 'images/inventar/weapon/27.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    manaCost = 10;
    permanentDamage = 0.6;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword28 extends Item {
  Sword28() {
    id = 'sword28';
    source = 'images/inventar/weapon/28.png';
    cost = 12;
    damage = 2;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    manaCost = 10;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword29 extends Item {
  Sword29() {
    id = 'sword29';
    source = 'images/inventar/weapon/29.png';
    cost = 12;
    damage = 2;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword30 extends Item {
  Sword30() {
    id = 'sword30';
    source = 'images/inventar/weapon/30.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword31 extends Item {
  Sword31() {
    id = 'sword31';
    source = 'images/inventar/weapon/31.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword32 extends Item {
  Sword32() {
    id = 'sword32';
    source = 'images/inventar/weapon/32.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.lightning;
    manaCost = 10;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword33 extends Item {
  Sword33() {
    id = 'sword33';
    source = 'images/inventar/weapon/33.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword34 extends Item {
  Sword34() {
    id = 'sword34';
    source = 'images/inventar/weapon/34.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    manaCost = 10;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword35 extends Item {
  Sword35() {
    id = 'sword35';
    source = 'images/inventar/weapon/35.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.poison;
    manaCost = 10;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword36 extends Item {
  Sword36() {
    id = 'sword36';
    source = 'images/inventar/weapon/36.png';
    cost = 12;
    damage = 2.7;
    attackSpeed = -0.01;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword37 extends Item {
  Sword37() {
    id = 'sword37';
    source = 'images/inventar/weapon/37.png';
    cost = 12;
    damage = 3;
    attackSpeed = 0.015;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword38 extends Item {
  Sword38() {
    id = 'sword38';
    source = 'images/inventar/weapon/38.png';
    cost = 12;
    damage = 3;
    attackSpeed = 0.015;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword39 extends Item {
  Sword39() {
    id = 'sword39';
    source = 'images/inventar/weapon/39.png';
    cost = 12;
    damage = 3;
    dressType = DressType.sword;
    permanentDamage = 1;
    secsOfPermDamage = 5;
    magicDamage = MagicDamage.ice;
    manaCost = 10;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword40 extends Item {
  Sword40() {
    id = 'sword40';
    source = 'images/inventar/weapon/40.png';
    cost = 12;
    damage = 3;
    dressType = DressType.sword;
    permanentDamage = 1;
    secsOfPermDamage = 5;
    magicDamage = MagicDamage.fire;
    manaCost = 10;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword41 extends Item {
  Sword41() {
    id = 'sword41';
    source = 'images/inventar/weapon/41.png';
    cost = 12;
    damage = 3;
    dressType = DressType.sword;
    permanentDamage = 1;
    secsOfPermDamage = 5;
    magicDamage = MagicDamage.poison;
    manaCost = 10;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword42 extends Item {
  Sword42() {
    id = 'sword42';
    source = 'images/inventar/weapon/42.png';
    cost = 12;
    damage = 3.3;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword43 extends Item {
  Sword43() {
    id = 'sword43';
    source = 'images/inventar/weapon/43.png';
    cost = 12;
    damage = 3.3;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword44 extends Item {
  Sword44() {
    id = 'sword44';
    source = 'images/inventar/weapon/44.png';
    cost = 12;
    damage = 3.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword45 extends Item {
  Sword45() {
    id = 'sword45';
    source = 'images/inventar/weapon/45.png';
    cost = 12;
    damage = 3.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword46 extends Item {
  Sword46() {
    id = 'sword46';
    source = 'images/inventar/weapon/46.png';
    cost = 12;
    damage = 3;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword47 extends Item {
  Sword47() {
    id = 'sword47';
    source = 'images/inventar/weapon/47.png';
    cost = 12;
    damage = 3;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword48 extends Item {
  Sword48() {
    id = 'sword48';
    source = 'images/inventar/weapon/48.png';
    cost = 12;
    damage = 3;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword49 extends Item {
  Sword49() {
    id = 'sword49';
    source = 'images/inventar/weapon/49.png';
    cost = 12;
    damage = 3.2;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(InventarType.sword, id);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}