//
//  AudioRecordUtility.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 18/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define AudioFolderName         @"RecordFoler"
#define DefaultAudioName        @"DefaultAudioFileName"
#import "AudioRecordUtility.h"

@implementation AudioRecordUtility
@synthesize audioDirectory;

-(id)init
{
    self = [super init];
    if (self) {
        self.audioDirectory = [[NSString alloc]init];
        self.audioDirectory = nil;
        [self createDirectory:AudioFolderName];
    }
    return self;
}

//AudioRecord配置

-(void)initlizationAudioRecord
{
    //配置Recorder，
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,
                                   [NSNumber numberWithInt:16],AVEncoderBitRateKey,
                                   [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                   [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                                   nil];
    //录音文件保存地址的URL
    NSURL *url = [NSURL URLWithString:[self saveRecordFileWithName:DefaultAudioName]];
    NSError *error = nil;
    if (self.audioRecorder) {
        [self.audioRecorder release];
        self.audioRecorder = nil;
    }
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    
    if (error != nil) {
        NSLog(@"Init audioRecorder error: %@",error);
    }else{
        if ([self.audioRecorder prepareToRecord]) {
            NSLog(@"Prepare successful");
        }
    }

}

//开始录音
-(void)startRecord
{
//    NSError *setCategoryError = nil;
//    [[AVAudioSession sharedInstance]
//     setCategory: AVAudioSessionCategoryAmbient
//     error: &setCategoryError];
//    UInt32 otherAudioIsPlaying;                                   // 1
//    UInt32 propertySize = sizeof (otherAudioIsPlaying);
//    
//    AudioSessionGetProperty (                                     // 2
//                             kAudioSessionProperty_OtherAudioIsPlaying,
//                             &propertySize,
//                             &otherAudioIsPlaying
//                             );
//    
//    if (otherAudioIsPlaying) {                                    // 3
//        [[AVAudioSession sharedInstance]
//         setCategory: AVAudioSessionCategoryAmbient
//         error: nil];
//    } else {
//        [[AVAudioSession sharedInstance]
//         setCategory: AVAudioSessionCategorySoloAmbient
//         error: nil];
//    }
    
    
    
    if (!self.audioRecorder.recording) {
        [self.audioRecorder record];
    }else {
        [self.audioRecorder stop];
    }
}

//播放录音
-(void)playRecordFile:(NSString *)fileName
{
    [self.audioRecorder stop];
//    NSURL * fileURL = [NSURL URLWithString:fileName];
    if (fileName == nil) {
        fileName = DefaultAudioName;
    }
    NSURL *fileURL = [NSURL URLWithString:[self saveRecordFileWithName:fileName]];

    if (!self.audioPlayer.playing) {
        NSError *error;
        if (self.audioPlayer) {
            [self.audioPlayer release];
            self.audioPlayer = nil;
        }
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        self.audioPlayer.delegate = self;
        if (error != nil) {
            NSLog(@"Wrong init player:%@", error);
        }else{
            [self.audioPlayer play];
        }

    }else {
        [self.audioPlayer pause];
    }
}


#pragma mark - 创建文件，目录相关操作
//创建录音文件目录
-(void)createDirectory:(NSString *)directoryName
{
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileDirectory = [path stringByAppendingPathComponent:directoryName];
    
    if (![defaultManager fileExistsAtPath:fileDirectory]) {
        [defaultManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }else
    {
        NSLog(@"Directory already exists");
    }
    [self setAudioDirectory:fileDirectory];
}

//录音文件位置,在delegate处可以更改文件的名字后保存
-(NSString *)saveRecordFileWithName:(NSString *)name
{
    if (audioDirectory == nil) {
        [self createDirectory:AudioFolderName];
    }
    NSString * formatName = [[NSString alloc]initWithFormat:@"%@.caf",name];
    NSString * saveFileName = [audioDirectory stringByAppendingPathComponent:formatName];
    saveFileName = [saveFileName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    return saveFileName;
}

#pragma mark audio delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //如果需要重命名文件，可以使用nsfilemanager 的
    //- (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
    
    
    NSLog(@"Finsh playing");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Finish record!");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}


#pragma  mark - public 
-(void)dealloc
{
    [super dealloc];
    [self.audioDirectory release];
    [self.audioRecorder release];
    [self.audioPlayer release];
}
@end
