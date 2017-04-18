//
//  ViewController.m
//  WaterWave
//
//  Created by 孙俊 on 2017/4/18.
//  Copyright © 2017年 SJ. All rights reserved.
//

#import "ViewController.h"
#import "WaterWaveView/SJWaterWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SJWaterWaveView * waveView = [[SJWaterWaveView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    waveView.progress = 0.6;
    waveView.waveMoveSpeed = 0.1;
    waveView.waveAmplitude = 7;
    waveView.firstWaveColor = [UIColor grayColor];
    waveView.secondWaveColor = [UIColor lightGrayColor];
    waveView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:waveView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
