import 'dart:ui';
import 'package:snakeai/snake_game.dart';
import 'package:flutter/painting.dart';

class ScoreDisplay {
  final SnakeGame game;
  TextPainter painter;
  Offset position;
  int score;

  ScoreDisplay(this.game, this.score) {
    TextStyle textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 90,
      shadows: <Shadow>[
        Shadow(
          color: Color(0xff000000),
          blurRadius: 7,
          offset: Offset(3, 3),
        )
      ],
    );

    painter = TextPainter(
      text: TextSpan(text: score.toString(), style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height / 2) - (painter.height / 2),
    );
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }
}
