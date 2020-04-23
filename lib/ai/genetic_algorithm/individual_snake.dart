import 'package:snakeai/directions.dart';
import 'package:snakeai/snake_game.dart';
import 'dart:ui';
import 'dart:math';
import 'neuron.dart';
import 'network.dart';

//@Genetic
class IndividualSnake {
  final SnakeGame game;
  int borderLeftTop;
  int borderRightBottom;

  //INPUTS
  int leftEmpty;
  int rightEmpty;
  int upEmpty;
  int downEmpty;
  int appleLeft;
  int appleRight;
  int appleUp;
  int appleDown;

  //DETAILS
  Network network; 
  int score = 0;
  List<List<double>> hiddenWeights;
  List<List<double>> outputWeights;
  bool gotDetails = false;


  IndividualSnake(this.game, bool firstGen, 
                   {List<List<double>> hlw, List<List<double>> olw}) {
		borderLeftTop = (game.gridSize * 3).round();
		borderRightBottom = (game.gridSize * 32).round();
    if(firstGen){
      network = Network(game, 20, firstGen);
    } else {
      network = Network(game, 20, firstGen, hlw: hlw, olw: olw);
    }
  }

  void getInputs(){
    double snakeX = game.head.targetLocation.dx;
    double snakeY = game.head.targetLocation.dy;
    double appleX = game.apple.rect.left;
    double appleY = game.apple.rect.top;
    Point oneLeft = Point((snakeX - game.gridSize).round(), snakeY.round());
    Point oneRight = Point((snakeX + game.gridSize).round(), snakeY.round());
    Point oneUp = Point(snakeX.round(), (snakeY - game.gridSize).round());
    Point oneDown = Point(snakeX.round(), (snakeY + game.gridSize).round());

    if(game.occupiedCoordinates.contains(oneLeft) || oneLeft.x == borderLeftTop){
      leftEmpty = 0;
    } else {
      leftEmpty = 1;
    }

    if(game.occupiedCoordinates.contains(oneRight) || oneRight.x == borderRightBottom){
      rightEmpty = 0;
    } else {
      rightEmpty = 1;
    }

    if(game.occupiedCoordinates.contains(oneUp) || oneUp.y == borderLeftTop){
      upEmpty = 0;
    } else {
      upEmpty = 1;
    }

    if(game.occupiedCoordinates.contains(oneDown) || oneDown.y == borderRightBottom){
      downEmpty = 0;
    } else {
      downEmpty = 1;
    }
  
    //APPLE INPUTS
    if(snakeX < appleX){
     appleLeft = 0; 
     appleRight = 1;
    } else {
     appleLeft = 1;
     appleRight = 0;
    }

    if(snakeY < appleY){
      appleUp = 0;
      appleDown = 1;
    } else {
      appleUp = 1;
      appleDown = 0;
    }
  }

  List<List<double>> getHiddenWeights(){
    List<List<double>> hiddenWeights = [];
    for(Neuron neuron in network.hiddenLayer){
      hiddenWeights.add(neuron.weights);  
    }
    return hiddenWeights;
  }

  List<List<double>> getOutputWeights(){
    List<List<double>> outputWeights = [];
    for(Neuron neuron in network.outputLayer){
      outputWeights.add(neuron.weights);  
    }
    return outputWeights;
    
  }

  void update(double timeDelta){
      score++;
      getInputs();
      List<int> inputs = [leftEmpty, rightEmpty, upEmpty, downEmpty,
                          appleLeft, appleRight, appleUp, appleDown];
      network.forwardPass(inputs);

      if(!gotDetails){
        hiddenWeights = getHiddenWeights();
        outputWeights = getOutputWeights();
        gotDetails = true;
      }
  }

  void printDetails(){
    print('-----------------------------');
    print('Gen: ${game.currentGeneration}, Snake: ${game.currentSnake}');
    print('Score: $score');
    print('Hidden Weights: $hiddenWeights');
    print('Output Weights: $outputWeights');
  }
}
