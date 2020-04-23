import 'package:snakeai/snake_game.dart';
import 'package:snakeai/directions.dart';
import 'neuron.dart';
import 'random_neuron.dart';

class Network {
  //final int numberOfLayers;
  final SnakeGame game;
  final int numberOfNeurons;
  List<Neuron> hiddenLayer = []; 
  List<int> hiddenLayerOutputs = [];
  List<Neuron> outputLayer = [];
  List<double> finalOutputs = [];

  Network(this.game, this.numberOfNeurons, bool firstGen, 
           {List<List<double>> hlw, List<List<double>> olw}){
    if(firstGen){
      setLayersRandom();
    } else {
      setLayers(hlw, olw);
    }
  }

  void setLayers(List<List<double>> hlw, List<List<double>> olw){
    for(int i = 0; i < numberOfNeurons; i++){
      Neuron neuron = Neuron();
      neuron.setWeights(hlw[i]);
      hiddenLayer.add(neuron);
    }

    for(int i = 0; i < 4; i++){
      Neuron neuron = Neuron();
      neuron.setWeights(olw[i]);
      outputLayer.add(neuron);
    }
  }

  void setLayersRandom(){
    for(int i = 0; i < numberOfNeurons; i++){
        hiddenLayer.add(RandomNeuron());
    }

    for(int i = 0; i < 4; i++){ // 4 because we have 4 directions to choose
        outputLayer.add(RandomNeuron());
    }
  }

  void forwardPass(List<int> inputs){
    calculateHiddenLayerOutputs(inputs);
    calculateFinalOutputs();
    //print(finalOutputs);
    moveSnake();
  }

  void calculateHiddenLayerOutputs(List<int> inputs){
    hiddenLayerOutputs.clear();
    for(Neuron neuron in hiddenLayer){
      hiddenLayerOutputs.add(neuron.getOutput(inputs));
    }
  }

  void calculateFinalOutputs(){
    finalOutputs.clear();
    for(Neuron neuron in outputLayer){
      finalOutputs.add(neuron.getFinalOutput(hiddenLayerOutputs)); 
    }
  }

  //ignoring because you can't move opposite direction in the game of snake
  int getHighestOutputIndex({int ignore}){
    int index;
    double max = -1;
    for(int i = 0; i < finalOutputs.length; i++){
      if(i != ignore && finalOutputs[i] > max){
        max = finalOutputs[i];
        index = i;
      }
    }
    return index;
  }

  void moveSnake(){
    int index;

    if(game.direction == Directions.LEFT){
      index = getHighestOutputIndex(ignore: 1);
    } else if(game.direction == Directions.RIGHT){
      index = getHighestOutputIndex(ignore: 0);
    } else if (game.direction == Directions.UP){
      index = getHighestOutputIndex(ignore: 3);
    } else if (game.direction == Directions.DOWN){
      index = getHighestOutputIndex(ignore: 2);
    }

    //removing points for moving away from the apple
    switch(index){
      case 0:
        game.direction = Directions.LEFT;
        if(game.generation[game.currentSnake].appleRight == 1){
          game.generation[game.currentSnake].score -= 1;
        }
        break;
      case 1:
        game.direction = Directions.RIGHT;
        if(game.generation[game.currentSnake].appleLeft == 1){
          game.generation[game.currentSnake].score -= 1;
        }
        break;
      case 2:
        game.direction = Directions.UP;
        if(game.generation[game.currentSnake].appleDown == 1){
          game.generation[game.currentSnake].score -= 1;
        }
        break;
      case 3:
        game.direction = Directions.DOWN;
        if(game.generation[game.currentSnake].appleUp == 1){
          game.generation[game.currentSnake].score -= 1;
        }
        break;
      default:
        break;
    }
  }
}
