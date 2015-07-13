//
//  BaseWorkViewController.h
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//
#define width_bt 50
#define bottom_height 50
#import <UIKit/UIKit.h>
#define bottom_height 50
typedef void (^onFinishBlock)(UIImage* image);
typedef void (^onCancelBlock)(void);
@interface BaseWorkViewController : UIViewController{
    onCancelBlock cblock;
    onFinishBlock fblock;
    UIImage *_originalImage;
}
@property (nonatomic,strong) UIImage *originalImage;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic, strong) UIImageView *targetImageView;
@property (nonatomic,strong) NSString* bottom_title;
-(instancetype)initWithImage:(UIImage *)image
                        onOK:(onFinishBlock)finishblock
                    onCancel:(onCancelBlock)cancelblock;

-(instancetype)initWithImageView:(UIImage *)image
                            onOK:(onFinishBlock)finishblock
                        onCancel:(onCancelBlock)cancelblock;


- (void)setTitle:(NSString *)bottom_title;

- (void)setFinish:(onFinishBlock)fblock
           Cancel:(onCancelBlock)cblock;

-(void) onClickCancel:(id)sender;
-(void) onClickFinish:(id)sender;

@end
