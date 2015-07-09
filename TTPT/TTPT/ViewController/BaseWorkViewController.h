//
//  BaseWorkViewController.h
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onFinishBlock)(UIImage* image);
typedef void (^onCancelBlock)(UIImage* image);
@interface BaseWorkViewController : UIViewController{
    onCancelBlock cblock;
    onFinishBlock fblock;
}
/**
 底部的标题
 */
@property(strong, nonatomic) NSString *title_str;
-(instancetype)initWithImage:(UIImage *)image onOK:(onFinishBlock)finishblock
                    onCancel:(onCancelBlock)cancelblock;

@end
