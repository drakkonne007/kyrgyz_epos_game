

import 'package:flame/components.dart';

class CountTimer extends TimerComponent
{
  CountTimer({required super.period, super.autoStart, super.onTick, super.repeat, super.removeOnFinish, this.count = 0, this.onEndCount})
  {
    currentCount = count;
  }
  int count = 0;
  int currentCount = 0;
  Function()? onEndCount;

  @override
  void onTick()
  {
    if(count > 0){
      currentCount--;
      if(currentCount < 0){
        onEndCount?.call();
        removeFromParent();
      }else{
        super.onTick();
      }
    }else{
      super.onTick();
    }
  }
}