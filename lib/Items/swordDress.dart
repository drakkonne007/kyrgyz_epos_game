import 'package:game_flame/abstracts/item.dart';
import 'package:game_flame/kyrgyz_game.dart';

class SwordStart extends Item
{
  SwordStart()
  {
    id = 'swordStart';
    source = 'images/inventar/weapon/4.png';
    dressType = DressType.sword;
    damage = 1;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override
  void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword1 extends Item
{
  Sword1()
  {
    id = 'sword1';
    source = 'images/inventar/weapon/4.png';
    cost = 50;
    damage = 1;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    source = 'images/inventar/weapon/3.png';
    cost = 50;
    attackSpeed = -0.002;
    damage = 1;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    source = 'images/inventar/weapon/1.png';
    cost = 50;
    damage = 1.2;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    source = 'images/inventar/weapon/8.png';
    cost = 50;
    damage = 0.8;
    attackSpeed = - 0.005;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword5 extends Item {
  Sword5() {
    id = 'sword5';
    source = 'images/inventar/weapon/6.png';
    cost = 50;
    damage = 1.2;
    attackSpeed = -0.004;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword6 extends Item {
  Sword6() {
    id = 'sword6';
    source = 'images/inventar/weapon/2.png';
    cost = 75;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword8 extends Item {
  Sword8() {
    id = 'sword8';
    source = 'images/inventar/weapon/5.png';
    cost = 75;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
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
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword13 extends Item {
  Sword13() {
    id = 'sword13';
    source = 'images/inventar/weapon/14.png';
    cost = 80;
    damage = 1.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword14 extends Item {
  Sword14() {
    id = 'sword14';
    source = 'images/inventar/weapon/15.png';
    cost = 80;
    damage = 1.6;
    attackSpeed = -0.009;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword15 extends Item {
  Sword15() {
    id = 'sword15';
    source = 'images/inventar/weapon/16.png';
    cost = 80;
    damage = 1.75;
    attackSpeed = -0.009;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword16 extends Item {
  Sword16() {
    id = 'sword16';
    source = 'images/inventar/weapon/18.png';
    cost = 80;
    damage = 1.5;
    attackSpeed = -0.011;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game)
  {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration})
  {
    game.playerData.setDress(this);
  }
}

class Sword17 extends Item {
  Sword17() {
    id = 'sword17';
    source = 'images/inventar/weapon/19.png';
    cost = 85;
    damage = 1.6;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword18 extends Item {
  Sword18() {
    id = 'sword18';
    source = 'images/inventar/weapon/20.png';
    cost = 100;
    damage = 1.6;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 0.2;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword19 extends Item {
  Sword19() {
    id = 'sword19';
    source = 'images/inventar/weapon/21.png';
    cost = 100;
    damage = 1.6;
    magicDamage = MagicDamage.fire;
    permanentDamage = 0.2;
    secsOfPermDamage = 3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword20 extends Item {
  Sword20() {
    id = 'sword20';
    source = 'images/inventar/weapon/22.png';
    cost = 12;
    damage = 1.8;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword21 extends Item {
  Sword21() {
    id = 'sword21';
    source = 'images/inventar/weapon/23.png';
    cost = 12;
    damage = 1.8;
    dressType = DressType.sword;
    attackSpeed = -0.008;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword22 extends Item {
  Sword22() {
    id = 'sword22';
    source = 'images/inventar/weapon/24.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    attackSpeed = -0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword23 extends Item {
  Sword23() {
    id = 'sword23';
    source = 'images/inventar/weapon/25.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    attackSpeed = -0.01;
    magicDamage = MagicDamage.ice;
    permanentDamage = 0.4;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword24 extends Item {
  Sword24() {
    id = 'sword24';
    source = 'images/inventar/weapon/26.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 0.6;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword25 extends Item {
  Sword25() {
    id = 'sword25';
    source = 'images/inventar/weapon/27.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 0.6;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword26 extends Item {
  Sword26() {
    id = 'sword26';
    source = 'images/inventar/weapon/28.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    permanentDamage = 0.6;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword27 extends Item {
  Sword27() {
    id = 'sword27';
    source = 'images/inventar/weapon/29.png';
    cost = 12;
    damage = 1.7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    permanentDamage = 0.6;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword28 extends Item {
  Sword28() {
    id = 'sword28';
    source = 'images/inventar/weapon/30.png';
    cost = 12;
    damage = 2;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword29 extends Item {
  Sword29() {
    id = 'sword29';
    source = 'images/inventar/weapon/31.png';
    cost = 12;
    damage = 2;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword30 extends Item {
  Sword30() {
    id = 'sword30';
    source = 'images/inventar/weapon/32.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword31 extends Item {
  Sword31() {
    id = 'sword31';
    source = 'images/inventar/weapon/33.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword32 extends Item {
  Sword32() {
    id = 'sword32';
    source = 'images/inventar/weapon/34.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.lightning;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword33 extends Item {
  Sword33() {
    id = 'sword33';
    source = 'images/inventar/weapon/35.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword34 extends Item {
  Sword34() {
    id = 'sword34';
    source = 'images/inventar/weapon/36.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword35 extends Item {
  Sword35() {
    id = 'sword35';
    source = 'images/inventar/weapon/37.png';
    cost = 12;
    damage = 2.3;
    dressType = DressType.sword;
    magicDamage = MagicDamage.poison;
    permanentDamage = 0.5;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword36 extends Item {
  Sword36() {
    id = 'sword36';
    source = 'images/inventar/weapon/38.png';
    cost = 12;
    damage = 2.7;
    attackSpeed = -0.01;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword37 extends Item {
  Sword37() {
    id = 'sword37';
    source = 'images/inventar/weapon/39.png';
    cost = 12;
    damage = 3;
    attackSpeed = 0.015;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword38 extends Item {
  Sword38() {
    id = 'sword38';
    source = 'images/inventar/weapon/40.png';
    cost = 12;
    damage = 3;
    attackSpeed = 0.015;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword39 extends Item {
  Sword39() {
    id = 'sword39';
    source = 'images/inventar/weapon/41.png';
    cost = 12;
    damage = 3;
    dressType = DressType.sword;
    permanentDamage = 1;
    secsOfPermDamage = 5;
    magicDamage = MagicDamage.ice;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword40 extends Item {
  Sword40() {
    id = 'sword40';
    source = 'images/inventar/weapon/42.png';
    cost = 12;
    damage = 3;
    dressType = DressType.sword;
    permanentDamage = 1;
    secsOfPermDamage = 5;
    magicDamage = MagicDamage.fire;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword41 extends Item {
  Sword41() {
    id = 'sword41';
    source = 'images/inventar/weapon/43.png';
    cost = 12;
    damage = 3;
    dressType = DressType.sword;
    permanentDamage = 1;
    secsOfPermDamage = 5;
    magicDamage = MagicDamage.poison;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword42 extends Item {
  Sword42() {
    id = 'sword42';
    source = 'images/inventar/weapon/44.png';
    cost = 12;
    damage = 3.3;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword43 extends Item {
  Sword43() {
    id = 'sword43';
    source = 'images/inventar/weapon/45.png';
    cost = 12;
    damage = 3.3;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword44 extends Item {
  Sword44() {
    id = 'sword44';
    source = 'images/inventar/weapon/46.png';
    cost = 12;
    damage = 3.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword45 extends Item {
  Sword45() {
    id = 'sword45';
    source = 'images/inventar/weapon/47.png';
    cost = 12;
    damage = 3.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword46 extends Item {
  Sword46() {
    id = 'sword46';
    source = 'images/inventar/weapon/48.png';
    cost = 12;
    damage = 3;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword47 extends Item {
  Sword47() {
    id = 'sword47';
    source = 'images/inventar/weapon/49.png';
    cost = 12;
    damage = 3;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword48 extends Item {
  Sword48() {
    id = 'sword48';
    source = 'images/inventar/weapon/50.png';
    cost = 12;
    damage = 3;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword49 extends Item {
  Sword49() {
    id = 'sword49';
    source = 'images/inventar/weapon/51.png';
    cost = 12;
    damage = 3.2;
    attackSpeed = -0.02;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword50 extends Item {
  Sword50() {
    id = 'sword50';
    source = 'images/inventar/weapon/52.png';
    cost = 12;
    damage = 4.3;
    attackSpeed = 0.02;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    permanentDamage = 1;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword51 extends Item {
  Sword51() {
    id = 'sword51';
    source = 'images/inventar/weapon/53.png';
    cost = 12;
    damage = 3.7;
    attackSpeed = -0.018;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword52 extends Item {
  Sword52() {
    id = 'sword52';
    source = 'images/inventar/weapon/54.png';
    cost = 12;
    damage = 4.2;
    attackSpeed = 0.018;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword53 extends Item {
  Sword53() {
    id = 'sword53';
    source = 'images/inventar/weapon/55.png';
    cost = 12;
    damage = 4.2;
    attackSpeed = -0.01;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword54 extends Item {
  Sword54() {
    id = 'sword54';
    source = 'images/inventar/weapon/56.png';
    cost = 12;
    damage = 4.2;
    attackSpeed = -0.025;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword55 extends Item {
  Sword55() {
    id = 'sword55';
    source = 'images/inventar/weapon/57.png';
    cost = 12;
    damage = 4.8;
    attackSpeed = 0.008;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword56 extends Item {
  Sword56() {
    id = 'sword56';
    source = 'images/inventar/weapon/58.png';
    cost = 12;
    damage = 4.8;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 1.3;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword57 extends Item {
  Sword57() {
    id = 'sword57';
    source = 'images/inventar/weapon/59.png';
    cost = 12;
    damage = 4.8;
    dressType = DressType.sword;
    magicDamage = MagicDamage.poison;
    permanentDamage = 1.3;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword58 extends Item {
  Sword58() {
    id = 'sword58';
    source = 'images/inventar/weapon/60.png';
    cost = 12;
    damage = 4.8;
    dressType = DressType.sword;
    attackSpeed = -0.007;
    magicDamage = MagicDamage.ice;
    permanentDamage = 1.3;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword59 extends Item {
  Sword59() {
    id = 'sword59';
    source = 'images/inventar/weapon/61.png';
    cost = 12;
    damage = 5.1;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 1.3;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword60 extends Item {
  Sword60() {
    id = 'sword60';
    source = 'images/inventar/weapon/62.png';
    cost = 12;
    damage = 5.1;
    dressType = DressType.sword;
    magicDamage = MagicDamage.poison;
    permanentDamage = 1.3;
    secsOfPermDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword61 extends Item {
  Sword61() {
    id = 'sword61';
    source = 'images/inventar/weapon/63.png';
    cost = 12;
    damage = 5.1;
    dressType = DressType.sword;
    attackSpeed = -0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword62 extends Item {
  Sword62() {
    id = 'sword62';
    source = 'images/inventar/weapon/64.png';
    cost = 12;
    damage = 5.1;
    dressType = DressType.sword;
    attackSpeed = -0.018;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword63 extends Item {
  Sword63() {
    id = 'sword63';
    source = 'images/inventar/weapon/65.png';
    cost = 12;
    damage = 5.1;
    dressType = DressType.sword;
    attackSpeed = -0.018;
    magicDamage = MagicDamage.ice;
    permanentDamage = 3;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword64 extends Item {
  Sword64() {
    id = 'sword64';
    source = 'images/inventar/weapon/66.png';
    cost = 12;
    damage = 5.1;
    dressType = DressType.sword;
    attackSpeed = -0.018;
    magicDamage = MagicDamage.poison;
    permanentDamage = 3;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword65 extends Item {
  Sword65() {
    id = 'sword65';
    source = 'images/inventar/weapon/67.png';
    cost = 12;
    damage = 6;
    dressType = DressType.sword;
    attackSpeed = 0.012;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword66 extends Item {
  Sword66() {
    id = 'sword66';
    source = 'images/inventar/weapon/68.png';
    cost = 12;
    damage = 6;
    dressType = DressType.sword;
    attackSpeed = 0.014;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword67 extends Item {
  Sword67() {
    id = 'sword67';
    source = 'images/inventar/weapon/69.png';
    cost = 12;
    damage = 6;
    dressType = DressType.sword;
    attackSpeed = 0.014;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword68 extends Item {
  Sword68() {
    id = 'sword68';
    source = 'images/inventar/weapon/70.png';
    cost = 12;
    damage = 6;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 2;
    secsOfPermDamage = 4;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword69 extends Item {
  Sword69() {
    id = 'sword69';
    source = 'images/inventar/weapon/71.png';
    cost = 12;
    damage = 6;
    dressType = DressType.sword;
    magicDamage = MagicDamage.poison;
    permanentDamage = 2;
    secsOfPermDamage = 4;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword70 extends Item {
  Sword70() {
    id = 'sword70';
    source = 'images/inventar/weapon/72.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword71 extends Item {
  Sword71() {
    id = 'sword71';
    source = 'images/inventar/weapon/73.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
    attackSpeed = -0.005;
    magicDamage = MagicDamage.lightning;
    permanentDamage = 2;
    secsOfPermDamage = 1;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword72 extends Item {
  Sword72() {
    id = 'sword72';
    source = 'images/inventar/weapon/74.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
    attackSpeed = -0.005;
    magicDamage = MagicDamage.lightning;
    permanentDamage = 3;
    secsOfPermDamage = 1;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword73 extends Item {
  Sword73() {
    id = 'sword73';
    source = 'images/inventar/weapon/75.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
    attackSpeed = -0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword74 extends Item {
  Sword74() {
    id = 'sword74';
    source = 'images/inventar/weapon/76.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
    magicDamage = MagicDamage.ice;
    permanentDamage = 2;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword75 extends Item {
  Sword75() {
    id = 'sword75';
    source = 'images/inventar/weapon/77.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 2;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword76 extends Item {
  Sword76() {
    id = 'sword76';
    source = 'images/inventar/weapon/78.png';
    cost = 12;
    damage = 6.5;
    dressType = DressType.sword;
    magicDamage = MagicDamage.poison;
    permanentDamage = 2;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword77 extends Item {
  Sword77() {
    id = 'sword77';
    source = 'images/inventar/weapon/79.png';
    cost = 12;
    damage = 7;
    dressType = DressType.sword;
    magicDamage = MagicDamage.fire;
    permanentDamage = 3;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword78 extends Item {
  Sword78() {
    id = 'sword78';
    source = 'images/inventar/weapon/80.png';
    cost = 12;
    damage = 7.3;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword79 extends Item {
  Sword79() {
    id = 'sword79';
    source = 'images/inventar/weapon/81.png';
    cost = 12;
    damage = 7.3;
    dressType = DressType.sword;
    attackSpeed = -0.008;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword80 extends Item {
  Sword80() {
    id = 'sword80';
    source = 'images/inventar/weapon/82.png';
    cost = 12;
    damage = 7.3;
    dressType = DressType.sword;
    attackSpeed = -0.006;
    magicDamage = MagicDamage.poison;
    permanentDamage = 2;
    secsOfPermDamage = 3;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword81 extends Item {
  Sword81() {
    id = 'sword81';
    source = 'images/inventar/weapon/83.png';
    cost = 12;
    damage = 9;
    dressType = DressType.sword;
    attackSpeed = 0.02;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword82 extends Item {
  Sword82() {
    id = 'sword82';
    source = 'images/inventar/weapon/84.png';
    cost = 12;
    damage = 9.1;
    dressType = DressType.sword;
    attackSpeed = 0.02;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword83 extends Item {
  Sword83() {
    id = 'sword83';
    source = 'images/inventar/weapon/85.png';
    cost = 12;
    damage = 7.1;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword84 extends Item {
  Sword84() {
    id = 'sword84';
    source = 'images/inventar/weapon/86.png';
    cost = 12;
    damage = 7.1;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword85 extends Item {
  Sword85() {
    id = 'sword85';
    source = 'images/inventar/weapon/87.png';
    cost = 12;
    damage = 7;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword86 extends Item {
  Sword86() {
    id = 'sword86';
    source = 'images/inventar/weapon/88.png';
    cost = 12;
    damage = 7;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword87 extends Item {
  Sword87() {
    id = 'sword87';
    source = 'images/inventar/weapon/89.png';
    cost = 12;
    damage = 7;
    dressType = DressType.sword;
    attackSpeed = -0.015;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword88 extends Item {
  Sword88() {
    id = 'sword88';
    source = 'images/inventar/weapon/90.png';
    cost = 12;
    damage = 9;
    dressType = DressType.sword;
    attackSpeed = 0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword89 extends Item {
  Sword89() {
    id = 'sword89';
    source = 'images/inventar/weapon/92.png';
    cost = 12;
    damage = 8;
    dressType = DressType.sword;
    attackSpeed = - 0.007;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword90 extends Item {
  Sword90() {
    id = 'sword90';
    source = 'images/inventar/weapon/95.png';
    cost = 12;
    damage = 10;
    dressType = DressType.sword;
    attackSpeed = - 0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword91 extends Item {
  Sword91() {
    id = 'sword91';
    source = 'images/inventar/weapon/96.png';
    cost = 12;
    damage = 10;
    dressType = DressType.sword;
    attackSpeed = - 0.01;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword92 extends Item {
  Sword92() {
    id = 'sword92';
    source = 'images/inventar/weapon/97.png';
    cost = 12;
    damage = 8;
    dressType = DressType.sword;
    attackSpeed = - 0.01;
    magicDamage = MagicDamage.lightning;
    secsOfPermDamage = 2;
    permanentDamage = 5;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword93 extends Item {
  Sword93() {
    id = 'sword93';
    source = 'images/inventar/weapon/98.png';
    cost = 12;
    damage = 10;
    dressType = DressType.sword;
    attackSpeed = - 0.013;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword94 extends Item {
  Sword94() {
    id = 'sword94';
    source = 'images/inventar/weapon/100.png';
    cost = 12;
    damage = 12;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword95 extends Item {
  Sword95() {
    id = 'sword95';
    source = 'images/inventar/weapon/107.png';
    cost = 12;
    damage = 2;
    attackSpeed = -0.05;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}

class Sword96 extends Item {
  Sword96() {
    id = 'sword96';
    source = 'images/inventar/weapon/113.png';
    cost = 12;
    damage = 12;
    magicDamage = MagicDamage.lightning;
    secsOfPermDamage = 4;
    permanentDamage = 5;
    dressType = DressType.sword;
  }

  @override
  void getEffect(KyrgyzGame game) {
    game.playerData.addToInventar(game.playerData.weaponInventar, this);
  }

  @override void getEffectFromInventar(KyrgyzGame game, {double? duration}) {
    game.playerData.setDress(this);
  }
}