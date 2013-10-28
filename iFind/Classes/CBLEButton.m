//
//  CBLEButton.m
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEButton.h"

@implementation CBLEButton
@synthesize uuid = _uuid;
- (void)dealloc
{
    [super dealloc];
    [_imageView release];
    [_textLabel release];
    [_uuid release];
    _imageView = nil;
    _textLabel = nil;
    _uuid = nil;
}

- (id)initWithFrame:(CGRect)frame
          withImage:(UIImage *)image
      withHighLight:(UIImage *)highlightImage
          withTitle:(NSString *)title withTag:(int)tag
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = YES;
        self.tag = tag;
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        NSString * bgImageName = nil,* bgHlImageName = nil;
        switch (tag) {
            case 1:
                bgImageName = @"Main_Frame_Wallet_N";
                bgHlImageName = @"Main_Frame_Wallet_H";
                break;
             case 2:
                bgImageName = @"Main_Frame_Key_N";
                bgHlImageName = @"Main_Frame_Key_H";
                break;
             case 3:
                bgImageName = @"Main_Frame_Bag_N";
                bgHlImageName = @"Main_Frame_Bag_H";
                break;
             case 4:
                bgImageName = @"Main_Frame_Kid_N";
                bgHlImageName = @"Main_Frame_Kid_H";
                break;
            default:
                break;
        }

        [_bgView setImage:[UIImage imageNamed:bgImageName]];
        [_bgView setHighlightedImage:[UIImage imageNamed:bgHlImageName]];
        [self addSubview:_bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 70)*.5f, (frame.size.height - 70)*.5f, 70, 70)];
        [_imageView setImage:image];
        if(highlightImage)
        {
            [_imageView setHighlightedImage:highlightImage];
        }
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}


- (void)setImage:(UIImage *)image withHighLight:(UIImage *)highlightImage
{
    if(_imageView)
    {
        if(image)
           [_imageView setImage:image];
        
        if(highlightImage)
            [_imageView setHighlightedImage:highlightImage];
    }
}


- (void)setHighlight:(BOOL)isHighlight
{
    if(_imageView)
    {
        [_imageView setHighlighted:isHighlight];
    }
    _isHighlight = isHighlight;
    [_bgView setHighlighted:isHighlight];
}

- (void)tapSelf:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Tap");
    if(self.tapHandler)
        self.tapHandler(gesture.view);
}


- (void)setUuid:(NSString *)uuid
{
    if(_uuid != nil)
    {
        [_uuid release];
    }
    _uuid = [uuid retain];
}

@end
