//
//  ButtonView.h
//  TTPT
//
//  Created by bu88 on 15/7/14.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

@property(nonatomic,strong)UILabel *iconfont;
@property(nonatomic,strong)UILabel *btntitle;
@property(nonatomic,strong)UIButton*btnframe;


-(void)setIconString:(NSString *)iconString;
-(void)setTitle:(NSString *)btntitle;
@end
