import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/util.dart';
import 'package:flame/flame.dart';
import 'package:snakeai/snake_game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Size initialDimensions = await Flame.util.initialDimensions();
  SharedPreferences storage = await SharedPreferences.getInstance();
  SnakeGame game = SnakeGame(initialDimensions, storage);
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  Util flameUtil = Util();
  //flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);
  flameUtil.addGestureRecognizer(tapper);

  runApp(game.widget);

  Flame.images.loadAll(<String>[
    'background.png',
    'play.png',
    'board.png',
    'apple.png',
    'head_up.png',
    'head_right.png',
    'head_down.png',
    'head_left.png',
    'body.png',
    'left.png',
    'up.png',
    'right.png',
    'down.png',
    'left_.png',
    'up_.png',
    'right_.png',
    'down_.png',
    'game_over.png',
    'tail_up.png',
    'tail_right.png',
    'tail_down.png',
    'tail_left.png',
    'ai_icon.png',
  ]);
}
