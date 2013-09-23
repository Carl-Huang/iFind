//
//  CBLEButton.m
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEButton.h"

@implementation CBLEButton

- (void)dealloc
{
    [super dealloc];
    [_imageView release];
    [_textLabel release];
    _imageView = nil;
    _textLabel = nil;
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
    }
    return self;
}

@end
