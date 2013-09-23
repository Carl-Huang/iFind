//
//  PhotoManager.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 18/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import "PhotoManager.h"


@implementation PhotoManager
@synthesize camera;
@synthesize pickingImageView;
@synthesize configureBlock;
-(id)initWithBlock:(ConfigureImageBlock)block
{
    self = [super init];
    if (self) {
        [self initCamera];
        [self initlizationPickImageView];
        self.configureBlock = [block copy];
        saveToDiskPath = nil;
        [self createDirectory];
    }
    return  self;
}
-(void)initCamera
{
    if (camera) {
        [camera release];
        camera  = nil;
    }
    camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
    isSaveToLibrary = YES;
	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else
	{
		NSLog(@"Camera not exist");
		return;
	}
	
    //仅对视频拍摄有效
	switch (qualityNum) {
		case 0:
			camera.videoQuality = UIImagePickerControllerQualityTypeHigh;
			break;
		case 1:
			camera.videoQuality = UIImagePickerControllerQualityType640x480;
			break;
		case 2:
			camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
		case 3:
			camera.videoQuality = UIImagePickerControllerQualityTypeLow;
			break;
		default:
			camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
			break;
	}
	
}

-(void)initlizationPickImageView
{
    if (pickingImageView) {
        [pickingImageView release];
        pickingImageView = nil;
    }
    pickingImageView= [[UIImagePickerController alloc] init];
	pickingImageView.delegate = self;
	pickingImageView.allowsEditing = YES;
	
	pickingImageView.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        //混合类型 photo + movie
		pickingImageView.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }

}

#pragma  mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"info = %@",info);
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
		
		if (isSaveToLibrary)
		{
			//保存视频到相册
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
			[library release];
		}
		
		//获取视频的某一帧作为预览
        [self getPreViewImg:url];
	}else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
		self.configureBlock(image);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveImage:image];
        });
		if (isSaveToLibrary)
		{
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeImageToSavedPhotosAlbum:[image CGImage]
									  orientation:(ALAssetOrientation)[image imageOrientation]
								  completionBlock:nil];
			[library release];
		}
		
		[image release];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
	isSaveToLibrary = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"Cancle it");
	[picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)getPreViewImg:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    [self performSelector:@selector(configureImageBlock:) withObject:img afterDelay:0.1];
    [img release];
}

-(void)configureImageBlock:(UIImage *) image
{
	NSLog(@"Review Image");
    self.configureBlock(image);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, YES), ^{
            [self saveImage:image];
    });

}

-(void)saveImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil)
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyyMMddHHmm";
    saveToDiskFileName = [[[fmt stringFromDate:now]stringByAppendingPathExtension:@"png"] retain];
    if ([imageData writeToFile:[saveToDiskPath stringByAppendingPathComponent:saveToDiskFileName] atomically:YES]) {
        NSLog(@"successfully write image to local disk");
    }else
    {
        NSLog(@"Failed to write image to locatl");
    }
}

//创建本地图片目录
-(void)createDirectory
{
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileDirectory = [path stringByAppendingPathComponent:@"PicFolder"];
    
    if (![defaultManager fileExistsAtPath:fileDirectory]) {
        [defaultManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }else
    {
        NSLog(@"Directory already exists");
    }
    saveToDiskPath = [[fileDirectory stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]retain];
}


-(void)dealloc
{
    [super dealloc];
    if (camera) {
        [camera release];
        camera = nil;
    }
    if (pickingImageView) {
        [pickingImageView release];
        pickingImageView = nil;
    }
    [saveToDiskFileName release];
}
@end
