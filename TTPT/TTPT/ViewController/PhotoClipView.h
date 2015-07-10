//
//  PhotoClipView.h
//  photoclip
//
//  Created by guohao on 15/5/2.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ct_Round = 0,
    ct_Hexa,
    ct_Default
}ClipType;

@interface PhotoClipView : UIView{
    ClipType type;
}
@property (nonatomic,strong) UIImage* image;

- (instancetype)initWithFrame:(CGRect)frame
                     withType:(ClipType)ctype;

- (instancetype)initWithRateFrame:(CGRect)frame;
- (void)setClipFrameRate:(float)rate;
- (UIImage*)getCropImage;
@end
