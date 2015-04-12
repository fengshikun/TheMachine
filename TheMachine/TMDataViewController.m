//
//  TMDataViewController.m
//  TheMachine
//
//  Created by 世坤冯 on 15/3/15.
//  Copyright (c) 2015年 世坤冯. All rights reserved.
//

#import "TMDataViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TMDataViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) NSString *configPath;//same as TMDataViewController configPath

@property (nonatomic, strong) CLLocationManager *locationManager;
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

-(void) viewDidLoad{
    [super viewDidLoad];
    
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }

}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
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
