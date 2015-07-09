//
//  _PhotoPicker.h
//  ΩPhotoPicker
//
//  Created by guohao on 15/7/3.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Photos;
typedef void (^onFinishBlock)(NSArray* assets);
typedef void (^onCancelBlock)(void);

@interface XPhotoPicker : NSObject{
    onCancelBlock cblock;
    onFinishBlock fblock;
}
@property (nonatomic)long maxCount;
@property (nonatomic,strong)UIViewController* viewcontroller;
- (instancetype)initWithViewController:(UIViewController*)vc
                                  onOK:(onFinishBlock)finishblock
                              onCancel:(onCancelBlock)cancelblock;
- (void)show;
@end
