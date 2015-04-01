//
//  NeuralNetwork.m
//  TheMachine
//
//  Created by 世坤冯 on 15/3/29.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import "NeuralNetwork.h"
#import "NeuralConfig.h"

@implementation NeuralNetwork
- (id)initWithConfig:(NeuralConfig*)neuralConfig
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        numl = neuralConfig.layerNumber;
        lsize = (int *)malloc(numl*sizeof(int));
        
        for(int i=0;i<numl;i++){
            lsize[i]=neuralConfig.layerNeuronNumbers[i];
        }
        
        //	allocate memory for output of each neuron
        out = (double **)malloc(numl*sizeof(double*));
        for(int i=0;i<numl;i++){
            out[i] = (double*)malloc(lsize[i]*sizeof(double));
        }
        
        //	allocate memory for delta
        delta =(double **)malloc(numl*sizeof(double*));
        
        for(int i=1;i<numl;i++){
            delta[i]=(double*)malloc(lsize[i]*sizeof(double));
        }
        
        //	allocate memory for weights
        weight =  (double***)malloc(numl*sizeof(double**));
        
        for(int i=1;i<numl;i++){
            weight[i]=(double**)malloc(lsize[i]*sizeof(double*));
        }
        for(int i=1;i<numl;i++){
            for(int j=0;j<lsize[i];j++){
                weight[i][j]=(double*)malloc((lsize[i-1]+1)*sizeof(double));
            }
        }
        
        //	allocate memory for previous weights
        prevDwt =  (double***)malloc(numl*sizeof(double**));
        
        for(int i=1;i<numl;i++){
            prevDwt[i]=(double**)malloc(lsize[i]*sizeof(double*));
        }
        for(int i=1;i<numl;i++){
            for(int j=0;j<lsize[i];j++){
                prevDwt[i][j]=(double*)malloc((lsize[i-1]+1)*sizeof(double));
            }
        }
        
        //	seed and assign random weights
        srand((unsigned)(time(NULL)));
        for(int i=1;i<numl;i++)
            for(int j=0;j<lsize[i];j++)
                for(int k=0;k<lsize[i-1]+1;k++)
                    weight[i][j][k]=(double)(rand())/(RAND_MAX/2) - 1;//32767
        
        //	initialize previous weights to 0 for first iteration
        for(int i=1;i<numl;i++)
            for(int j=0;j<lsize[i];j++)
                for(int k=0;k<lsize[i-1]+1;k++)
                    prevDwt[i][j][k]=(double)0.0;
        
        
        beta = neuralConfig.beta;
        thresh = neuralConfig.thresh;
        maxIterTime = neuralConfig.maxIterTime;
        alpha = 0;
    }
    
    // Return the address of the newly initialized object
    return self;
}
- (void)dealloc
{
    //	free out
    for(int i=0;i<numl;i++)
        free(out[i]);
    free(out);
    
    //	free delta
    for(int i=1;i<numl;i++)
        free(delta[i]);
    free(delta);
    
    //	free weight
    for(int i=1;i<numl;i++)
        for(int j=0;j<lsize[i];j++)
            free(weight[i][j]);
    for(int i=1;i<numl;i++)
        free(weight[i]);
    free(weight);
    
    //	free prevDwt
    for(int i=1;i<numl;i++)
        for(int j=0;j<lsize[i];j++)
            free(prevDwt[i][j]);
    for(int i=1;i<numl;i++)
        free(prevDwt[i]);
    free(prevDwt);
    
    //	free layer info
    free(lsize);
    NSLog(@"Destroyed: %@", self);
}


//	sigmoid function
- (double) sigmoid: (double)in
{
    return (double)(1/(1+exp(-in)));
}

//	mean square error
- (double)mse:(double *)tgt
{
    double mse=0;
    for(int i=0;i<lsize[numl-1];i++){
        mse+=(tgt[i]-out[numl-1][i])*(tgt[i]-out[numl-1][i]);
    }
    return mse/2;
}


//	returns i'th output of the net
- (double) Out:(int)i
{
    return out[numl-1][i];
}

// feed forward one set of input
-(void) ffwd:(double *)in
{
    double sum;
    
    //	assign content to input layer
    for(int i=0;i<lsize[0];i++)
        out[0][i]=in[i];  // output_from_neuron(i,j) Jth neuron in Ith Layer
    
    //	assign output(activation) value
    //	to each neuron usng sigmoid func
    for(int i=1;i<numl;i++){				// For each layer
        for(int j=0;j<lsize[i];j++){		// For each neuron in current layer
            sum=0.0;
            for(int k=0;k<lsize[i-1];k++){		// For input from each neuron in preceeding layer
                sum+= out[i-1][k]*weight[i][j][k];	// Apply weight to inputs and add to sum
            }
            sum+=weight[i][j][lsize[i-1]];		// Apply bias
            out[i][j]=[self sigmoid:sum];				// Apply sigmoid function
        }
    }
}


//	backpropogate errors from output
//	layer uptill the first hidden layer
- (void)bpinput:(double *)in output:(double *)tgt
{
    double sum;
    
    //	update output values for each neuron
    [self ffwd:in];
    
    //	find delta for output layer
    for(int i=0;i<lsize[numl-1];i++){
        delta[numl-1][i]=out[numl-1][i]*
        (1-out[numl-1][i])*(tgt[i]-out[numl-1][i]);
    }
    
    //	find delta for hidden layers
    for(int i=numl-2;i>0;i--){
        for(int j=0;j<lsize[i];j++){
            sum=0.0;
            for(int k=0;k<lsize[i+1];k++){
                sum+=delta[i+1][k]*weight[i+1][k][j];
            }
            delta[i][j]=out[i][j]*(1-out[i][j])*sum;
        }
    }
    
    //	apply momentum ( does nothing if alpha=0 )
    for(int i=1;i<numl;i++){
        for(int j=0;j<lsize[i];j++){
            for(int k=0;k<lsize[i-1];k++){
                weight[i][j][k]+=alpha*prevDwt[i][j][k];
            }
            weight[i][j][lsize[i-1]]+=alpha*prevDwt[i][j][lsize[i-1]];
        }
    }
    
    //	adjust weights usng steepest descent	
    for(int i=1;i<numl;i++){
        for(int j=0;j<lsize[i];j++){
            for(int k=0;k<lsize[i-1];k++){
                prevDwt[i][j][k]=beta*delta[i][j]*out[i-1][k];
                weight[i][j][k]+=prevDwt[i][j][k];
            }
            prevDwt[i][j][lsize[i-1]]=beta*delta[i][j];
            weight[i][j][lsize[i-1]]+=prevDwt[i][j][lsize[i-1]];
        }
    }
}

//todo 一维数组向二维数组转化
-(void) trainData :(double**) Data
        withLength:(int) length
         dimension:(int) dimension
{
    for (long i=0; i<maxIterTime ; i++)
    {
        [self bpinput:Data[i%length] output:&Data[i%length][dimension]];
        if ([self mse:&Data[i%length][dimension]] < thresh) {
            break;
        }
        
    }
}
@end
