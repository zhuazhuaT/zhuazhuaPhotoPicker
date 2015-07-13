//
//  ZZBorderPickViewController.h
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderToolsView.h"
#import "BaseWorkViewController.h"
@class ZZBorderPickViewController;
typedef void (^PickBorder)(ZZBorderPickViewController *pickView,UIImage *image);

@interface ZZBorderPickViewController : BaseWorkViewController
@property(nonatomic,strong) BorderToolsView *borderToolsView;

-(instancetype)initWithImage:(UIImage *)image;

@end
