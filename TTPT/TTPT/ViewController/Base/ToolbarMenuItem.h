//
//  ToolbarMenuItem.h
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageToolInfo.h"
@interface ToolbarMenuItem : UIView
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
}
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) ImageToolInfo *toolInfo;
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ImageToolInfo*)toolInfo;


@end
