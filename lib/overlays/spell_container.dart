import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

class SpellContainer extends StatefulWidget
{
  const SpellContainer({super.key, required this.game});
  final KyrgyzGame game;

  @override
  State<StatefulWidget> createState() => _SpellContainerState();
}

class _SpellContainerState extends State<SpellContainer>
{
  int _currentStatus = 0;

  @override
  void initState()
  {
    _currentStatus = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                AutoSizeText(widget.game.playerData.getFreeSpellPoints().toString(), style: defaultInventarTextStyleGood, minFontSize: 35, maxLines: 1, textAlign: TextAlign.center,),
                Image.asset('assets/images/inventar/UI-9-sliced object-113.png', width: 60,),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
              [
                ElevatedButton(
                    onPressed: () {
                      if(_currentStatus == 0){
                        return;
                      }
                      setState(() {
                        _currentStatus = 0;
                      });
                    },
                    style: defaultNoneButtonStyle
                        .copyWith(
                      maximumSize: WidgetStateProperty
                          .all<Size>(
                          const Size(70, 70)),
                      backgroundBuilder: ((context,
                          state, child) {
                        return
                          Image.asset(
                            _currentStatus == 0 ? 'assets/images/inventar/UI-9-sliced object-64.png' : 'assets/images/inventar/UI-9-sliced object-49NoShadow.png',
                            fit: BoxFit.fill,
                            width: 70,);
                      }),
                    ),
                    child: null
                ),
                ElevatedButton(
                    onPressed: () {
                      if(_currentStatus == 1){
                        return;
                      }
                      setState(() {
                        _currentStatus = 1;
                      });
                    },
                    style: defaultNoneButtonStyle
                        .copyWith(
                      maximumSize: WidgetStateProperty
                          .all<Size>(
                          const Size(70, 70)),
                      backgroundBuilder: ((context,
                          state, child) {
                        return
                          Image.asset(
                            _currentStatus == 1 ? 'assets/images/inventar/UI-9-sliced object-66.png' : 'assets/images/inventar/UI-9-sliced object-51RawNoShadow.png',
                            fit: BoxFit.fill,
                            width: 70,);
                      }),
                    ),
                    child: null
                ),
                ElevatedButton(
                    onPressed: () {
                      if(_currentStatus == 2){
                        return;
                      }
                      setState(() {
                        _currentStatus = 2;
                      });
                    },
                    style: defaultNoneButtonStyle
                        .copyWith(
                      maximumSize: WidgetStateProperty
                          .all<Size>(
                          const Size(70, 70)),
                      backgroundBuilder: ((context,
                          state, child) {
                        return
                          Image.asset(
                            _currentStatus == 2 ? 'assets/images/inventar/UI-9-sliced object-52ManaGreen.png' : 'assets/images/inventar/UI-9-sliced object-52ManaNoShadow.png',
                            fit: BoxFit.fill,
                            width: 70,);
                      }),
                    ),
                    child: null
                )
              ]
          ),
          Expanded(
              child: getSpellVariants(_currentStatus)
          )
          //
        ]
    );
  }

  Widget getSpellVariants(int variant)
  {
    List<String> temp;
    int levelSpell = 0;
    switch(variant){
      case 0:
        temp = _healthSpells;
        levelSpell = widget.game.playerData.levelHealthSpells;
        break;
      case 1:
        temp = _strongSpells;
        levelSpell = widget.game.playerData.levelStaminaSpells;
        break;
      default:
        temp = _manaSpells;
        levelSpell = widget.game.playerData.levelManaSpells;
        break;
    }

    return  CustomScrollView(
        slivers: <Widget>
        [
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  addRepaintBoundaries: false,
                  childCount: temp.length, (BuildContext context, int index)
              {
                return Row(
                    children:
                    [
                      Expanded(
                          flex:1,
                          child:
                          ElevatedButton(
                              onPressed: () async{
                                if(index < levelSpell){
                                  return;
                                }
                                if(widget.game.playerData.getFreeSpellPoints() < 1){
                                  await notSpellPoint(context);
                                  return;
                                }
                                if(levelSpell == index){
                                  bool? answer = await askForSpelling(context);
                                  if(answer != null && answer == true){
                                    setState(() {
                                      addSpell(variant);
                                    });
                                  }
                                }else{
                                  await notSpellPoint(context);
                                  return;
                                }
                              },
                              style: defaultNoneButtonStyle
                                  .copyWith(
                                backgroundBuilder: ((context,
                                    state, child) {
                                  return
                                    Image.asset(
                                      index < levelSpell ? 'assets/images/inventar/activePageBall.png' : 'assets/images/inventar/passivePageBall.png',
                                      fit: BoxFit.fill,);
                                }),
                              ),
                              child: null
                          )),
                      const SizedBox(width: 5,),
                      Expanded(
                          flex:10,
                          child:Container(
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(minHeight: 80),
                              decoration: const BoxDecoration(image: DecorationImage(
                                image: AssetImage('assets/images/inventar/UI-9-sliced object-121.png',),
                                centerSlice: Rect.fromLTWH(30,26,4,12),
                              )),
                              child: Container(margin: const EdgeInsets.all(15),
                                  child: AutoSizeText(temp[index], style: defaultInventarTextStyleGood, maxLines: 2, minFontSize: 10,textAlign: TextAlign.center,))
                          ))
                    ]
                );
              }
              )
          )]);
  }

  void addSpell(int variant)
  {
    switch(variant){
      case 0:
        widget.game.playerData.levelHealthSpells++;
        break;
      case 1:
        widget.game.playerData.levelStaminaSpells++;
        break;
      default:
        widget.game.playerData.levelManaSpells++;
        break;
    }
    widget.game.playerData.recalcSpells();
  }
}

List<String> _healthSpells = [
  'Увеличить здоровье на 10',
  'Ускорить регенерацию на 10%',
  'Плюс 5% получить половину урона и увернуться от удара',
  'Плюс 5% получить половину урона и увернуться от удара',
  'Вампиризм от оружия 5%',
  'Плюс 5% получить половину урона и увернуться от удара',
  'Увеличить здоровье на 10',
  'Увеличить здоровье на 10',
];

List<String> _strongSpells = [
  'Усилить блок на 5 урона',
  'Ускорить регенерацию силы на 10%',
  'Усилить блок на 5 урона',
  'Блок не отнимает энергии',
  'Добавить 10 к силе',
  'Защита полностью блокирует физический урон',
  'Добавить 10 к силе',
  'Защита блокирует 25% магического урона',
];

List<String> _manaSpells = [
  'Увеличить ману на 10',
  'Увеличить регенарацию на 20%',
  'Увеличить ману на 10',
  'Дополнительный шар от колец',
  'Уворот наносит урон 30 противникам через которых ты прошёл',
  'Увеличить ману на 10',
  'Дополнительный шар от колец',
];

Future<bool?> askForSpelling(BuildContext context)
async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFdfc08e),
        content: const Text('Изучить навык?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Да'),
          ),
        ],
      );
    },
  );
}

Future<bool?> notSpellPoint(BuildContext context)
async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFdfc08e),
        content: const Text('Недостаточно опыта!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ок'),
          ),
        ],
      );
    },
  );
}

