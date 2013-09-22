//
//  VPlayer.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 16/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define VolumeChangeNotificaton @"AVSystemController_SystemVolumeDidChangeNotification"
#import "AlarmPlayer.h"
#import "VAudioHelper.h"

@implementation AlarmPlayer
@synthesize soundPlay;
@synthesize soundVolume;
@synthesize vibrateTimer;
@synthesize audioHelper;

-(id)init
{
    self = [super init];
    if (self) {
        //监听app到后台消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endTaskInBackground:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(beginTaskInBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        audioHelper = [[VAudioHelper alloc]init];
        [audioHelper initSession];
        
    }
    return self;
}

-(void)playSoundWithName:(NSString * )musicName
{
    if (self.soundPlay) {
        [self.soundPlay release];
    }
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path])
        NSLog(@"File not Existed");
    self.soundPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    if (!self.soundPlay)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    [self.soundPlay prepareToPlay];
    //无限循环
    [self.soundPlay setNumberOfLoops:-1];
    [self.soundPlay setVolume:1.0];
    
    //设置震动
    vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
    
    //监听声音的输入输出源的改变
    [self addHardKeyVolumeListener];
    
    //监听静音键
    [self addMutedListener];
    
    //设置系统音量到最大
    [self maxinumAudioSound];

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (BOOL) prepAudioWithAudioName:(NSString *)musicName withNumberOfLoops:(NSInteger)number Volume:(float)volumn
{
    if (self.soundPlay) {
        [self.soundPlay release];
    }
    self.soundVolume = volumn;
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return NO;
    self.soundPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    if (!self.soundPlay)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
    [self.soundPlay prepareToPlay];
    [self.soundPlay setNumberOfLoops:number];
    [self.soundPlay setVolume:self.soundVolume];
    
    
    
    //设置震动
    vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
    
    //监听声音的输入输出源的改变
    [self addHardKeyVolumeListener];
    
    //监听静音键
    [self addMutedListener];
    
    //设置系统音量到最大
    [self maxinumAudioSound];
       return YES;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}


#pragma  mark - Background Task

-(void)endTaskInBackground:(NSNotification *)noti
{
     [self endBackgroundUpdateTask];
}

-(void)beginTaskInBackground:(NSNotification *)noti
{
    NSLog(@"BeginTaskInBackground");
    [self beingBackgroundUpdateTask];
    //运行要在后台运行的操作
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doSomething_Carl) userInfo:nil repeats:YES];
    [self startPlay];
}
-(void)doSomething_Carl
{
    NSLog(@" you can do something,carl");
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    if (self.backgroundUpdateTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
        self.backgroundUpdateTask = UIBackgroundTaskInvalid;
    }
}

#pragma mark - 监听音量键和静音键
//监听音量键
- (BOOL)addHardKeyVolumeListener
{
    OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                                 audioVolumeChangeListenerCallback,
                                                 self);
    return s == kAudioSessionNoError;
}
//音量键回调函数：
void audioVolumeChangeListenerCallback (void *inUserData,
                                        AudioSessionPropertyID inPropertyID,
                                        UInt32 inPropertyValueSize,
                                        const void *inPropertyValue)
{
    AlarmPlayer * _player = (AlarmPlayer *)inUserData;
    if (inPropertyID != kAudioSessionProperty_CurrentHardwareOutputVolume) return;
    Float32 value = *(Float32 *)inPropertyValue;
    _player.mpc.volume = 0.3;
    NSLog(@"%f",value);
}

//监听静音键：
- (BOOL)addMutedListener
{
    OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                                 audioRouteChangeListenerCallback,
                                                 self);
    return s == kAudioSessionNoError;
}
//回调函数：

void audioRouteChangeListenerCallback (void *inUserData,
                                       AudioSessionPropertyID inPropertyID,
                                       UInt32 inPropertyValueSize,
                                       const void *inPropertyValue
                                       )
{
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
//    BOOL muted = [mediaVolume isMuted];
    // add code here
}


#pragma mark - public method
-(void)maxinumAudioSound
{
    self.mpc = [MPMusicPlayerController applicationMusicPlayer];
    self.mpc.volume = 1.0;
    
}

//手机震动
-(void)vibrate
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

//开始播放
-(void)startPlay
{
    [self.soundPlay play];
}

//停止播放
-(void)stopPlaying
{
    [audioHelper checkAndPrepareCategoryForRecording];
    if (self.soundPlay) {
        [vibrateTimer invalidate];
        vibrateTimer = nil;
        [self.soundPlay stop];
        [self.soundPlay release];
        self.soundPlay = nil;
    }
}


-(void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
