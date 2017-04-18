//
//  SJWaterWaveView.h
//  WaterWave
//
//  Created by 孙俊 on 2017/4/18.
//  Copyright © 2017年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJWaterWaveView : UIView

/** 进度 */
@property(nonatomic,assign)CGFloat progress;

/** 波浪1颜色 */
@property (nonatomic,strong)UIColor * firstWaveColor;

/** 波浪2颜色 */
@property (nonatomic,strong)UIColor * secondWaveColor;

/** 背景颜色 */
@property (nonatomic,strong)UIColor * waveBackgroundColor;

/** 曲线移动速度 */
@property (nonatomic,assign) CGFloat waveMoveSpeed;

/** 曲线振幅 */
@property (nonatomic,assign) CGFloat waveAmplitude;

/** 停止动画 */
-(void)stop;


@end
