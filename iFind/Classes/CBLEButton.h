//
//  CBLEButton.h
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLEButton : UIView
{
    UIImageView * _imageView;
    UILabel * _textLabel;
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image withHighLight:(UIImage *)highlightImage withTitle:(NSString *)title;


@end
