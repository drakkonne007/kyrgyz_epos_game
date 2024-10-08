import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/kyrgyz_game.dart';
import 'package:game_flame/overlays/game_styles.dart';

class QuestContainer extends StatelessWidget
{
  const QuestContainer({super.key, required this.game});
  final KyrgyzGame game;

  @override
  Widget build(BuildContext context){
    List<String> temp = game.tempQuestForInventarOverlay.keys.toList(growable: false);
    return  CustomScrollView(
        slivers: <Widget>[SliverList(
            delegate: SliverChildBuilderDelegate(
                addRepaintBoundaries: false,
                childCount: temp.length, (BuildContext context, int index)
                {
                  return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 3, right: 3, bottom: 3, top: 6),
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF739461)
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [BoxShadow(color: Color(0xFF705c4d), spreadRadius: 1, blurRadius: 1)]
                      ),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(temp[index],style: defaultInventarTextStyleGold,minFontSize: 15,maxLines: 2,),
                          AutoSizeText(game.tempQuestForInventarOverlay[temp[index]]!,style: defaultInventarTextStyle,minFontSize: 15,maxLines: 10,)
                        ],
                      )

                  );
                }
            )
        )]);
  }

}