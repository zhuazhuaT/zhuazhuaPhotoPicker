//
//  StickerViewController.h
//  payment
//
//  Created by guohao on 15/7/8.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Sticker;
typedef void (^onSelectStickerBlock)(Sticker* sticker);
@interface StickerViewController : UIViewController{
    onSelectStickerBlock selectblock;
}

- (void)setSelectBlock:(onSelectStickerBlock)block;
@end
