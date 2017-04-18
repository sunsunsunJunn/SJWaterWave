# SJWaterWave

一个圆形水波浪效果
![image](https://github.com/sunsunsunJunn/SJWaterWave/blob/master/waterWave.gif) 

创建显示并且一些属性

```
SJWaterWaveView * waveView = [[SJWaterWaveView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
waveView.progress = 0.6;
waveView.waveMoveSpeed = 0.1;
waveView.waveAmplitude = 7;
waveView.firstWaveColor = [UIColor grayColor];
waveView.secondWaveColor = [UIColor lightGrayColor];
waveView.backgroundColor = [UIColor blackColor];
[self.view addSubview:waveView];
```
