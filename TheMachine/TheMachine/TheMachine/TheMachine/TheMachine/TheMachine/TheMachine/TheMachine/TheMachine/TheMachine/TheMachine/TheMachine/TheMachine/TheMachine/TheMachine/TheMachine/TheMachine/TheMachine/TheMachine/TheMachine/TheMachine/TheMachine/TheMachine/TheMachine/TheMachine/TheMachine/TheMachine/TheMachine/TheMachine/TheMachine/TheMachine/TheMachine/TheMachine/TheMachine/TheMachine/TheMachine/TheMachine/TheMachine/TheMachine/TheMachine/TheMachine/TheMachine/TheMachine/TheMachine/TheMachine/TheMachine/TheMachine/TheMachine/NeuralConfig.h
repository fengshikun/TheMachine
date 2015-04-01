//
//  NeuralConfig.h
//  TheMachine
//
//  Created by 世坤冯 on 15/3/29.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeuralConfig : NSObject <NSCoding>

@property int layerNumber;
@property double beta;
@property double thresh;
@property double maxIterTime;

@property int *layerNeuronNumbers;

@end
