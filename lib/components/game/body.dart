import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class Body {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;
  Offset targetLocation;
  Offset previousTarget;
  int indexInBodyParts;

  Body(this.game, {double x, double y, this.indexInBodyParts}) {
    rect = Rect.fromLTWH(x, y, game.gridSize, game.gridSize);
    sprite = Sprite('body.png');
    previousTarget = Offset(rect.left, rect.top);
    setTargetLocation();
  }

  void setTargetLocation() {
    if (indexInBodyParts == 0) {
      targetLocation = game.head.previousTarget;
    } else {
      targetLocation = game.bodyParts[indexInBodyParts - 1].previousTarget;
    }
  }

  void checkIfTail(Offset toTarget) {
    if (indexInBodyParts == game.bodyParts.length - 1) {
      switch (toTarget.direction.round()) {
        //each case is N-E-S-W in radians rounded to nearest int
        case -2:
          sprite = Sprite('tail_up.png');
          break;
        case 0:
          sprite = Sprite('tail_right.png');
          break;
        case 2:
          sprite = Sprite('tail_down.png');
          break;
        case 3:
          sprite = Sprite('tail_left.png');
          break;
      }
    } else {
      sprite = Sprite('body.png');
    }
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }

  void update(double timeDelta) {
    double singleFrameDistance = game.speed * timeDelta;
    Offset toTarget = targetLocation - Offset(rect.left, rect.top);

    if (singleFrameDistance < toTarget.distance) {
      Offset singleFrameShift =
          Offset.fromDirection(toTarget.direction, singleFrameDistance);
      rect = rect.shift(singleFrameShift);
    } else {
      rect = rect.shift(toTarget);
      previousTarget = targetLocation;
      setTargetLocation();
    }

    checkIfTail(toTarget);
  }
}
