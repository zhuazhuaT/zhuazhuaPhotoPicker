//
//  BaseWorkViewController.h
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onFinishBlock)(UIImage* image);
typedef void (^onCancelBlock)(void);
@interface BaseWorkViewController : UIViewController{
    onCancelBlock cblock;
    onFinishBlock fblock;
}
@property (nonatomic,strong) NSString* bottom_title;
-(instancetype)initWithImage:(UIImage *)image
                        onOK:(onFinishBlock)finishblock
                    onCancel:(onCancelBlock)cancelblock;
-(void)setTitle:(NSString *)title;

@end
