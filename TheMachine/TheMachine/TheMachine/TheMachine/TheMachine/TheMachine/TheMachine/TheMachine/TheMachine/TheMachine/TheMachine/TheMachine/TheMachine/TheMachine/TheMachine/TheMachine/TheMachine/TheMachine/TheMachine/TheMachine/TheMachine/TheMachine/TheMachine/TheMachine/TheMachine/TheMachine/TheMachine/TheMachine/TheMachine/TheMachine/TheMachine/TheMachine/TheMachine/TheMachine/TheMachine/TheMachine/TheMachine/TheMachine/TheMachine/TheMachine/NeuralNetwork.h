//
//  NeuralNetwork.h
//  TheMachine
//
//  Created by 世坤冯 on 15/3/29.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeuralNetwork : NSObject
{
    //	output of each neuron
    double **out;
    
    //	delta error value for each neuron
    double **delta;
    
    //	vector of weights for each neuron
    double ***weight;
    
    //	no of layers in net
    //	including input layer
    int numl;
    
    //	vector of numl elements for size
    //	of each layer
    int *lsize;
    
    //	learning rate
    double beta;
    
    //	momentum parameter
    double alpha;
    
    //	storage for weight-change made
    //	in previous epoch
    double ***prevDwt;
    
    double thresh;
    double maxIterTime;
}
@end
