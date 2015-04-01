//
//  NeuralConfig.m
//  TheMachine
//
//  Created by 世坤冯 on 15/3/29.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import "NeuralConfig.h"

@implementation NeuralConfig
- (id)initWithlayerNumber:(int)layerNumber
       layerNeuronNumbers:(int*)layerNeuronNumbers
                     beta:(double)beta
                   thresh:(double)thresh
              maxIterTime:(double)maxIterTime
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.layerNumber = layerNumber;
        self.beta = beta;
        self.thresh = thresh;
        self.maxIterTime = maxIterTime;
        
        //remember to dealloc
        self.layerNeuronNumbers = layerNeuronNumbers;
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //encode an int array is complex
    [aCoder encodeObject: [NSNumber numberWithInt:self.layerNumber] forKey:@"layerNumber"];
    
    NSData *data = [NSData dataWithBytesNoCopy:self.layerNeuronNumbers length:sizeof(int) * self.layerNumber freeWhenDone:NO];
    [aCoder encodeObject:data forKey:@"layerNeuronNumbers"];
    
    [aCoder encodeObject: [NSNumber numberWithDouble:self.beta] forKey:@"beta"];
    [aCoder encodeObject: [NSNumber numberWithDouble:self.thresh] forKey:@"thresh"];
    [aCoder encodeObject: [NSNumber numberWithDouble:self.maxIterTime] forKey:@"maxIterTime"];
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.layerNumber = [[aDecoder decodeObjectForKey:@"layerNumber"] intValue];
        
        //decode int array via NSData
        NSData *data = [aDecoder decodeObjectForKey:@"layerNeuronNumbers"];
        if (data) {
            NSUInteger length = [data length];
            self.layerNeuronNumbers = (int *)malloc(length);
            [data getBytes:_layerNeuronNumbers length:length];
        }
        
        self.beta= [[aDecoder decodeObjectForKey:@"beta"] doubleValue];
        self.thresh= [[aDecoder decodeObjectForKey:@"thresh"] doubleValue];
        self.maxIterTime= [[aDecoder decodeObjectForKey:@"maxIterTime"] doubleValue];
    }
    return self;
}

- (id) init
{
    int *layerNeuronNumbers = (int*)calloc(5,sizeof(int));
    for (int i=0; i<5; i++) {
        if (i==4) {
            layerNeuronNumbers[i]=1;
            continue;
        }
        layerNeuronNumbers[i] = 5;
    }
    return [self initWithlayerNumber:5
                  layerNeuronNumbers:(int*)layerNeuronNumbers
                                beta:0.3
                              thresh:0.001
                         maxIterTime:1000];
}

- (void)dealloc
{
    if (self.layerNeuronNumbers!=NULL) {
        free(self.layerNeuronNumbers);
        self.layerNeuronNumbers=NULL;
    }
    NSLog(@"Destroyed: %@", self);
}
@end
