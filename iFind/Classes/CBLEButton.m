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
          withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = YES;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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


- (void)setHighlight:(BOOL)isHighlight
{
    if(_imageView)
    {
        [_imageView setHighlighted:isHighlight];
    }
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
