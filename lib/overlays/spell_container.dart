import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';

enum SpellVariant
{
  health,
  strong,
  mana
}

class Spell
{
  Spell({required this.description, required this.isBought});
  String description;
  bool isBought = false;
}

class SpellContainer extends StatefulWidget
{
  const SpellContainer({super.key, required this.game});
  final KyrgyzGame game;

  @override
  State<StatefulWidget> createState() => _SpellContainerState();
}

class _SpellContainerState extends State<SpellContainer>
{
  @override
  Widget build(BuildContext context) {

  }
}


Widget getSpellVariants(SpellVariant variant)
{
  List<Spell> temp;
  switch(variant){
    case SpellVariant.health:
      temp = _healthSpells;
      break;
    case SpellVariant.strong:
      temp = _strongSpells;
      break;
    case SpellVariant.mana:
      temp = _manaSpells;
      break;
  }
  return  CustomScrollView(
      slivers: <Widget>[SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: temp.length, (BuildContext context, int index)
          {
            return Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                children:
                [
                  Container(
                      width: _size.width * 0.3,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF739461)
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [BoxShadow(color: Color(0xFF705c4d), spreadRadius: 1, blurRadius: 1)]
                      ),
                      child:
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset('assets/${curItem.source}',fit: BoxFit.contain),
                          ),
                          Expanded(
                              flex: 6,
                              child: Column(
                                  children: infoAboutChoosen(curItem,false,count,false)
                              )
                          )
                        ],
                      )
                  ),
                ]
            );
          }
          )
      )]);
}

List<Spell> _healthSpells = [
  Spell(description: 'Увеличить здоровье на 10', isBought: false),
  Spell(description: 'Ускорить регенерацию на 20%', isBought: false),
  Spell(description: '10% получить половину урона и увернуться от удара', isBought: false),
  Spell(description: 'Увеличить здоровье на 10', isBought: false),
  Spell(description: '15% получить половину урона и увернуться от удара', isBought: false),
  Spell(description: 'Увеличить здоровье на 10', isBought: false),
];

List<Spell> _strongSpells = [
  Spell(description: 'Усилить блок на 5 урона', isBought: false),
  Spell(description: 'Ускорить регенерацию на 10%', isBought: false),
  Spell(description: 'Блок не отнимает энергии', isBought: false),
  Spell(description: 'Усилить блок на 5 урона', isBought: false),
  Spell(description: 'Добавить 10 к силе', isBought: false),
  Spell(description: 'Защита полностью блокирует физический урон', isBought: false),
  Spell(description: 'Добавить 10 к силе', isBought: false),
  Spell(description: 'Защита блокирует 25% магического урона', isBought: false),
];

List<Spell> _manaSpells = [
  Spell(description: 'Увеличить ману на 10', isBought: false),
  Spell(description: 'Увеличить регенарацию на 20%', isBought: false),
  Spell(description: 'Увеличить ману на 10', isBought: false),
  Spell(description: 'Дополнительный шар от колец', isBought: false),
  Spell(description: 'Уворот наносит урон противникам через которых ты прошёл', isBought: false),
  Spell(description: 'Увеличить ману на 10', isBought: false),
  Spell(description: 'Дополнительный шар от колец', isBought: false),
];

