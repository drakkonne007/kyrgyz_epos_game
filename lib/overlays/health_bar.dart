

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_flame/components/physic_vals.dart';
import 'dart:math' as math;


class HealthBar extends StatefulWidget
{
  static const id = 'HealthBar';
  @override
  State<HealthBar> createState() => _HealthBarState();

  var myTextStyle =  TextStyle( fontSize: 45, letterSpacing: 0.5, fontFamily: 'Samson');
}

class _HealthBarState extends State<HealthBar> {
  var _health = OrthoPlayerVals.health.value;
  var _armor = OrthoPlayerVals.armor.value;
  var _energy = OrthoPlayerVals.energy.value;
  double currentRun = 1;
  double _percRun = 1;
  double _percHealth = 1;
  double _percArm = 1;

  _HealthBarState() {
    OrthoPlayerVals.health.addListener(() {
      _health = OrthoPlayerVals.health.value;
      _percHealth = _health / OrthoPlayerVals.maxHealth;
      if(mounted) {
        setState(() {
        });
      }
    });
    OrthoPlayerVals.armor.addListener(() {
      _armor = OrthoPlayerVals.armor.value;
      _percArm = _armor / OrthoPlayerVals.maxArmor;
      if(mounted) {
        setState(() {
        });
      }
    });
    OrthoPlayerVals.energy.addListener(() {
      _energy = OrthoPlayerVals.energy.value;
      _percRun = _energy / OrthoPlayerVals.maxEnergy;
      if(mounted) {
        setState(() {
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(left: 10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      children:[
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(gradient: SweepGradient(
                              stops: [0.0,_percHealth,_percHealth,1],
                              colors: [Colors.red.withAlpha(180),Colors.red.withAlpha(180), Colors.black.withAlpha(180), Colors.black.withAlpha(180)],
                              transform: GradientRotation(-math.pi/2)), shape: BoxShape.circle),
                          child: const Icon(Icons.heart_broken, color: Colors.red,size: 35,
                            shadows: [
                              BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),spreadRadius: 1, blurStyle: BlurStyle.normal)
                            ],),
                        ),
                        SizedBox(width: 5, height: 0,),
                        Text('$_health',style: widget.myTextStyle.copyWith(color: Colors.red[700]!),),
                      ]
                  ),
                  SizedBox(width: 1, height: 8,),
                  Row(
                      children:[
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(gradient: SweepGradient(
                              stops: [0.0,_percArm,_percArm,1],
                              colors: [Colors.green.withAlpha(180),Colors.green.withAlpha(180), Colors.black.withAlpha(180), Colors.black.withAlpha(180)],
                              transform: GradientRotation(-math.pi/2)), shape: BoxShape.circle),
                          child: const Icon(Icons.shield_sharp, color: Colors.green,size: 35,
                            shadows: [
                              BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),spreadRadius: 1, blurStyle: BlurStyle.normal)
                            ],),
                        ),
                        SizedBox(width: 5, height: 0,),
                        Text('$_armor',style: widget.myTextStyle.copyWith(color: Colors.green[700]!),),
                      ]
                  ),
                  SizedBox(width: 1, height: 8,),
                  Row(
                    children:[
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(gradient: SweepGradient(
                            stops: [0.0,_percRun,_percRun,1],
                            colors: [Colors.blue.withAlpha(180),Colors.blue.withAlpha(180), Colors.black.withAlpha(180), Colors.black.withAlpha(180)],
                            transform: GradientRotation(-math.pi/2)), shape: BoxShape.circle),
                        child: const Icon(Icons.directions_run, color: Colors.blue,size: 35,
                          shadows: [
                            BoxShadow(color: Colors.black,blurRadius: 5,offset: Offset(-1,1),spreadRadius: 1, blurStyle: BlurStyle.normal)
                          ],),
                      ),
                      SizedBox(width: 5, height: 0,),
                      Text(_energy.toStringAsFixed(1),style: widget.myTextStyle.copyWith(color: Colors.blue[700]!),),
                    ],
                  )
                ]

            )
        )
    );
  }
}