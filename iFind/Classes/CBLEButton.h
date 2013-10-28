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
    UIImageView * _bgView;
}
@property (nonatomic,assign) BOOL isHighlight;
@property (nonatomic,copy) TapHandler  tapHandler;
@property (nonatomic,retain) NSString * uuid;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image withHighLight:(UIImage *)highlightImage withTitle:(NSString *)title withTag:(int)tag;
- (void)setHighlight:(BOOL)isHighlight;
- (void)setUuid:(NSString *)uuid;
- (void)setImage:(UIImage *)image withHighLight:(UIImage *)highlightImage;
@end
