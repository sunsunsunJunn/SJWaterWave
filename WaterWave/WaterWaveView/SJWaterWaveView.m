//
//  SJWaterWaveView.m
//  WaterWave
//
//  Created by 孙俊 on 2017/4/18.
//  Copyright © 2017年 SJ. All rights reserved.
//

#import "SJWaterWaveView.h"

#define SJDefaultFirstWaveColor [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:1]
#define SJDefaultSecondWaveColor [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:0.3]
#define SJDefaultBackGroundColor [UIColor colorWithRed:96/255.0f green:159/255.0f blue:150/255.0f alpha:1]

// 默认高度
static CGFloat const SJWaveAmplitude = 10;
//默认初相
static CGFloat const SJWaveX = 0;

@interface SJWaterWaveView()
{
    CADisplayLink *_disPlayLink;
    /** 曲线角速度 */
    CGFloat _wavePalstance;
    /** 曲线初相 */
    CGFloat _waveX;
    /** 曲线偏距 */
    CGFloat _waveY;
}
 /** 两条波浪 */
@property (nonatomic,strong)CAShapeLayer * waveLayer1;
@property (nonatomic,strong)CAShapeLayer * waveLayer2;

@end

@implementation SJWaterWaveView

/**
 正弦曲线公式可表示为y=Asin(ωx+φ)+k：
 A，振幅，最高和最低的距离
 W，角速度，用于控制周期大小，单位x中的起伏个数
 K，偏距，曲线整体上下偏移量
 φ，初相，左右移动的值
 
 这个效果主要的思路是添加两条曲线 一条正玄曲线、一条余弦曲线 然后在曲线下添加深浅不同的背景颜色，从而达到波浪显示的效果
 */

-(CAShapeLayer *)waveLayer1{
    if (!_waveLayer1) {
        _waveLayer1 = [CAShapeLayer layer];
        _waveLayer1.fillColor = SJDefaultFirstWaveColor.CGColor;
        _waveLayer1.strokeColor = SJDefaultFirstWaveColor.CGColor;
    }
    return _waveLayer1;
}

-(CAShapeLayer *)waveLayer2{
    if (!_waveLayer2) {
        _waveLayer2 = [CAShapeLayer layer];
        _waveLayer2.fillColor = SJDefaultSecondWaveColor.CGColor;
        _waveLayer2.strokeColor = SJDefaultSecondWaveColor.CGColor;
    }
    return _waveLayer2;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, MIN(frame.size.width, frame.size.height), MIN(frame.size.width, frame.size.height));
        //振幅
        _waveAmplitude = SJWaveAmplitude;
        //角速度
        _wavePalstance = M_PI/self.bounds.size.width;
        //偏距
        _waveY = self.bounds.size.height;
        //初相
        _waveX = SJWaveX;
        //x轴移动速度
        _waveMoveSpeed = _wavePalstance * 2;
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //初始化波浪
    [self.layer addSublayer:self.waveLayer1];
    //上层
    [self.layer addSublayer:self.waveLayer2];
    //圆
    self.layer.cornerRadius = self.bounds.size.width/2.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = SJDefaultBackGroundColor;
}

#pragma mark -- 波动动画实现
- (void)waveAnimation:(CADisplayLink *)link{
    _waveX += _waveMoveSpeed;
    [self updateWaveY];//更新波浪的高度位置
    [self startWaveAnimation];//波浪轨迹和动画
}
//更新偏距的大小 直到达到目标偏距 让wave有一个匀速增长的效果
-(void)updateWaveY
{
    CGFloat targetY = self.bounds.size.height - _progress * self.bounds.size.height;
    if (_waveY < targetY) {
        _waveY += 2;
    }
    if (_waveY > targetY ) {
        _waveY -= 2;
    }
}

-(void)startWaveAnimation
{
    //波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGMutablePathRef maskPath = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //设置起始位置
    CGPathMoveToPoint(maskPath, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX) + _waveY;
        
        CGPathAddLineToPoint(path, nil, x, y);
        
    }
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * cos(_wavePalstance * x + _waveX) + _waveY;
        
        CGPathAddLineToPoint(maskPath, nil, x, y);
    }
    [self updateLayer:_waveLayer1 path:path];
    [self updateLayer:_waveLayer2 path:maskPath];
    
    if (self.firstWaveColor) {
        self.waveLayer1.fillColor = self.firstWaveColor.CGColor;
        self.waveLayer1.strokeColor = self.firstWaveColor.CGColor;
    }
    if (self.secondWaveColor) {
        self.waveLayer2.fillColor = self.secondWaveColor.CGColor;
        self.waveLayer2.strokeColor = self.secondWaveColor.CGColor;
    }
}

-(void)updateLayer:(CAShapeLayer *)layer path:(CGMutablePathRef )path
{
    //填充底部颜色
    CGFloat waterWaveWidth = self.bounds.size.width;
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    layer.path = path;
    CGPathRelease(path);
}


#pragma mark - setter

-(void)setWaveBackgroundColor:(UIColor *)waveBackgroundColor{
    _waveBackgroundColor = waveBackgroundColor;
    self.backgroundColor = waveBackgroundColor;
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (_disPlayLink) {
        [_disPlayLink invalidate];
        _disPlayLink = nil;
    }
    
    //以屏幕刷新速度为周期刷新曲线的位置
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation:)];
    [_disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - 停止动画
-(void)stop
{
    if (_disPlayLink) {
        [_disPlayLink invalidate];
        _disPlayLink = nil;
    }
}

-(void)dealloc
{
    [self stop];
    if (_waveLayer1) {
        [_waveLayer1 removeFromSuperlayer];
        _waveLayer1 = nil;
    }
    if (_waveLayer2) {
        [_waveLayer2 removeFromSuperlayer];
        _waveLayer2 = nil;
    }
    
}

@end
