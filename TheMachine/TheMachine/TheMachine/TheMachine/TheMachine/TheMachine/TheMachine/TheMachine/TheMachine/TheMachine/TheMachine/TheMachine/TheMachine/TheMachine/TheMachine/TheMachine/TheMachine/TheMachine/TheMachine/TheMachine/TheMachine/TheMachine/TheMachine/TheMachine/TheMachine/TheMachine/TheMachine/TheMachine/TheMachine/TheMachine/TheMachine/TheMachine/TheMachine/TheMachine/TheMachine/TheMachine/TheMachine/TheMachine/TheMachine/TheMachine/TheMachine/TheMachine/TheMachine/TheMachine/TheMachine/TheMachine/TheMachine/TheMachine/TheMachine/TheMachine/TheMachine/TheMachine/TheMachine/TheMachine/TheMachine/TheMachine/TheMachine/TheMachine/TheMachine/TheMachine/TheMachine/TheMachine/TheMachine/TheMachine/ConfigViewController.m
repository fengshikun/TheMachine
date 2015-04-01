//
//  ConfigViewController.m
//  TheMachine
//
//  Created by 世坤冯 on 15/3/29.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import "ConfigViewController.h"
#import "NeuralConfig.h"

@interface ConfigViewController ()
@property (weak, nonatomic) IBOutlet UITextField *layerNumber;
@property (weak, nonatomic) IBOutlet UITextField *layerNeuronNumbers;
@property (weak, nonatomic) IBOutlet UITextField *Beta;
@property (weak, nonatomic) IBOutlet UITextField *thresh;
@property (weak, nonatomic) IBOutlet UITextField *maxIterTime;

@property (nonatomic) NSString *configPath;
@property (nonatomic) NeuralConfig *neuralConfig;
@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)saveConfig:(id)sender {
    
    
}
- (BOOL)saveChanges
{
    NSString *path = [self configPath];
    return [NSKeyedArchiver archiveRootObject:self.neuralConfig toFile:path];
}
- (void)loadConfig
{
    NSString *path = [self configPath];
    _neuralConfig = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!_neuralConfig) {
        _neuralConfig = [[NeuralConfig alloc]init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)loadConfig{
    
}


- (NSString *)configArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"neuralConfig.archive"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
