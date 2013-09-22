//
//  VAudioHelper.h
//  DisableOtherAudioPlaying
//
//  Created by vedon on 16/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface VAudioHelper : NSObject {
    BOOL recording;
}

- (void)initSession;
- (BOOL)hasHeadset;
- (BOOL)hasMicphone;
- (void)cleanUpForEndRecording;
- (BOOL)checkAndPrepareCategoryForRecording;
@end
