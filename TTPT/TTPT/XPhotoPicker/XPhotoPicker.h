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
typedef void (^onFinishPickerBlock)(NSArray* assets);
typedef void (^onCancelPickerBlock)(void);

@interface XPhotoPicker : NSObject{
    onCancelPickerBlock cblock;
    onFinishPickerBlock fblock;
}
@property (nonatomic)long maxCount;
@property (nonatomic,strong)UIViewController* viewcontroller;
- (instancetype)initWithViewController:(UIViewController*)vc
                                  onOK:(onFinishPickerBlock)finishblock
                              onCancel:(onCancelPickerBlock)cancelblock;
- (void)show;
@end
