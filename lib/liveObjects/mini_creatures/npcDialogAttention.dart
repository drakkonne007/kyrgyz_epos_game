import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:game_flame/components/physic_vals.dart';

class NpcDialogAttention extends SpriteAnimationComponent {
  NpcDialogAttention(this._isDone,{required super.position});

  final Vector2 source = Vector2(264 / 8, 28);
  bool _isDone;

  @override
  void onLoad() async
  {
    anchor = const Anchor(0.5, 0.5);
    priority = GamePriority.maxPriority;
    var spriteSheet = SpriteSheet(
      image: await Flame.images.load(
          _isDone ? 'images/npc-icon-attention-grey.png' : 'images/npc-icon-attention.png'),
      srcSize: source,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0);
  }
}