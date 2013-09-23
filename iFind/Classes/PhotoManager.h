//
//  PhotoManager.h
//  DisableOtherAudioPlaying
//
//  Created by vedon on 18/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^ConfigureImageBlock) (id item);
@interface PhotoManager : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger qualityNum;
    BOOL isSaveToLibrary;
    NSString *saveToDiskFileName;
}
@property (retain,  nonatomic)      UIImagePickerController *camera;
@property (retain,  nonatomic)      UIImagePickerController *pickingImageView;
@property (copy,    nonatomic)      ConfigureImageBlock     configureBlock;
-(id)initWithBlock:(ConfigureImageBlock)block;
@end
