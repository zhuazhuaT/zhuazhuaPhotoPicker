//
//  StickerEditViewController.h
//  TTPT
//
//  Created by guohao on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BaseWorkViewController.h"
#import <UIKit/UIKit.h>
@class Sticker;
@interface StickerEditViewController : BaseWorkViewController
- (instancetype)initWithImage:(UIImage*)image
                      sticker:(Sticker*)sticker;


@end
