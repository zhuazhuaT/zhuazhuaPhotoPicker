//
//  ButtonView.m
//  TTPT
//
//  Created by bu88 on 15/7/14.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ButtonView.h"
#import "UIView+Frame.h"
@implementation ButtonView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconfont = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,frame.size.width, 43)];
        self.btntitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconfont.bottom, frame.size.width, 14)];
        self.btnframe = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.iconfont setContentMode:UIViewContentModeCenter];
        [self.iconfont setTextAlignment:NSTextAlignmentCenter];
        [self.btntitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.iconfont];
        [self addSubview:self.btntitle];
        [self addSubview:self.btnframe];
        UIFont *font = [UIFont fontWithName:@"iconfont" size:30];
        [self.iconfont setFont:font];
    }
    return self;
}

-(void)setIconString:(NSString *)iconString{
    [self.iconfont setText:iconString];
}

-(void)setTitle:(NSString *)btntitle{
    [self.btntitle setText:btntitle];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.iconfont setFrame:CGRectMake(0, 0,frame.size.width, 43)];
    [self.btntitle setFrame:CGRectMake(0, self.iconfont.bottom, frame.size.width, 14)];
    [self.btnframe setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

@end
