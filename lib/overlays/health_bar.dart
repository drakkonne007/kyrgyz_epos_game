

import 'package:flutter/material.dart';
import 'package:game_flame/components/physic_vals.dart';


class HealthBar extends StatefulWidget
{
  static const id = 'HealthBar';
  @override
  State<HealthBar> createState() => _HealthBarState();
}

class _HealthBarState extends State<HealthBar> {
  int _health = OrthoPLayerVals.health.value;
  _HealthBarState() {
    OrthoPLayerVals.health.addListener(() {
      setState(() {
        _health = OrthoPLayerVals.health.value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Text('$_health',
        textScaleFactor: 3,)
    );
  }
}