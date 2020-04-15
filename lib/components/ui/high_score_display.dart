import 'dart:ui';
import 'package:snakeai/snake_game.dart';
import 'package:flutter/painting.dart';

class HighScoreDisplay {
  final SnakeGame game;
  TextPainter painter;
  Offset position;
  int highScore;

  HighScoreDisplay(this.game, this.highScore) {
    Shadow shadow = Shadow(
      color: Color(0xff000000),
      blurRadius: 5,
      offset: Offset.zero,
    );

    TextStyle textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 30,
      shadows: <Shadow>[shadow, shadow, shadow, shadow],
    );

    painter = TextPainter(
      text: TextSpan(text: 'High Score: $highScore', style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
//      (game.screenSize.height / 2) -
//          (painter.height / 2) +
//          game.scoreDisplay.painter.height,
      (game.screenSize.height * 0.75) + (painter.height / 2),
    );
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }
}
