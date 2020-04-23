import 'dart:math';
import 'neuron.dart';

class RandomNeuron extends Neuron {
  List<int> inputs; 
  List<double> weights = [];
  double activation;
  int output;
  Random rnd = Random();
  bool weightsSet = false;


  setInputs(List<int> inputs){
    this.inputs = inputs;
  }
 
  setRandomWeights(){
    for(int i = 0; i < inputs.length; i++){
      weights.add((rnd.nextDouble() * 2) - 1); 
    }
    weights.add((rnd.nextDouble() * 2) - 1); // adding the bias
  }

  calculateActivation(){
    activation = 0;
    for(int i = 0; i < inputs.length; i++){
      activation += inputs[i] * weights[i];
    }
    activation += -1 * weights[weights.length - 1];

    //bias = (rnd.nextDouble() * 2) - 1;
    //activation += (-1 * bias);
  }

  int getOutput(List<int> inputs){
    setInputs(inputs);
    if(!weightsSet){
      setRandomWeights();
      weightsSet = true;
    }
    calculateActivation();
    if(sigmoidFunction(activation) >= 0.5){
      output = 1;
      return 1;
    } else {
      output = 0;
      return 0;
    }
  }

  double getFinalOutput(List<int> inputs){
    setInputs(inputs);
    if(!weightsSet){
      setRandomWeights();
      weightsSet = true;
    }
    calculateActivation();
    return sigmoidFunction(activation);
  }


}
