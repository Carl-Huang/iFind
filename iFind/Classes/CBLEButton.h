//
//  CBLEButton.h
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapHandler)(id sender);
@interface CBLEButton : UIView
{
    UIImageView * _imageView;
    UILabel * _textLabel;
}
@property (nonatomic,copy) TapHandler  tapHandler;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image withHighLight:(UIImage *)highlightImage withTitle:(NSString *)title;
- (void)setHighlight:(BOOL)isHighlight;

@end
