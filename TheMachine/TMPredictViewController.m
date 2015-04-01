//
//  TMPredictViewController.m
//  TheMachine
//
//  Created by 世坤冯 on 15/3/15.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import "TMPredictViewController.h"

@interface TMPredictViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *outsideField;
@property (weak, nonatomic) IBOutlet UITextField *resultField;
@end

@implementation TMPredictViewController
- (IBAction)predictAction:(id)sender {

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set the tab bar item's title
        self.tabBarItem.title = @"TMPredict";
        
        // Create a UIImage from a file
        UIImage *image = [UIImage imageNamed:@"fly.png"];
        
        //[image drawInRect:CGRectMake(0, 0, 30, 30)];
        // Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    
    return self;
}
@end
