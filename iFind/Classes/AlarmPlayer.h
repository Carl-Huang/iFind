//
//  VPlayer.h
//  DisableOtherAudioPlaying
//
//  Created by vedon on 16/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class VAudioHelper;
@interface AlarmPlayer : NSObject

@property (retain, nonatomic)   AVAudioPlayer               * soundPlay;
@property (nonatomic,assign)    float                       soundVolume;
@property (retain, nonatomic)   NSTimer                     * vibrateTimer;
@property (retain, nonatomic)   MPMusicPlayerController     *mpc;
@property (assign, nonatomic)   UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (retain, nonatomic)   VAudioHelper                *audioHelper;
-(id)init;
- (BOOL) prepAudioWithAudioName:(NSString *)musicName withNumberOfLoops:(NSInteger)number Volume:(float)volumn;
-(void)stopPlaying;
-(void)startPlay;
-(void)playSoundWithName:(NSString * )musicName;
@end
