//
//  TMDataViewController.m
//  TheMachine
//
//  Created by 世坤冯 on 15/3/15.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import "TMDataViewController.h"

@interface TMDataViewController ()
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) NSString *configPath;//same as TMDataViewController configPath
@end

@implementation TMDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set the tab bar item's title
        self.tabBarItem.title = @"TMData";
        
        // Create a UIImage from a file
        UIImage *image = [UIImage imageNamed:@"load.png"];
        
        //[image drawInRect:CGRectMake(0, 0, 30, 30)];
        // Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    
    return self;
}

- (IBAction)saveData:(id)sender {
    
}

- (IBAction)trainNeural:(id)sender {
}


-(void) saveTrainData:(NSMutableArray *)newItem
{
    NSMutableArray * oldData = [NSMutableArray arrayWithContentsOfFile:_configPath];
    [oldData addObjectsFromArray:newItem];
    [oldData writeToFile:_configPath atomically:YES];
}

-( double *) loadTrainData
{
    NSMutableArray * oldData = [NSMutableArray arrayWithContentsOfFile:_configPath];
    const double* arrayDoubles = (const double*)[[NSData dataWithData:oldData] bytes];
    double *trainData = (double *)malloc(sizeof([[NSData dataWithData:oldData] bytes]));
    memcpy(trainData, arrayDoubles, sizeof([[NSData dataWithData:oldData] bytes]));
    return trainData;
}
@end
