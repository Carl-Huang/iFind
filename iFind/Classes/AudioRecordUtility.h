//
//  AudioRecordUtility.h
//  DisableOtherAudioPlaying
//
//  Created by vedon on 18/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioRecordUtility : NSObject<AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property (retain, nonatomic) AVAudioRecorder *audioRecorder;
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) NSString * audioDirectory;

-(id)init;
-(void)initlizationAudioRecord;
-(void)startRecord;
-(void)playRecordFile:(NSString *)fileName;
@end
