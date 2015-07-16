//
//  ToolbarMenuItem.m
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ToolbarMenuItem.h"
#import "UIView+Frame.h"
@implementation ToolbarMenuItem

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = frame.size.width;
        CGFloat H = frame.size.height;
        
        _iconView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, H-20)];
        _iconView.backgroundColor = [UIColor clearColor];
        UIFont *font = [UIFont fontWithName:@"iconfont" size:40];
        [_iconView setFont:font];
//        _iconView.clipsToBounds = YES;
//        _iconView.layer.cornerRadius = (W - 20)/2;
        [_iconView setTextAlignment:NSTextAlignmentCenter];
//        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom, W, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ImageToolInfo *)toolInfo{
    self = [self initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:gesture];
        
        self.toolInfo = toolInfo;
        [self setTitle:toolInfo.title];
        [self setIconString:toolInfo.iconString];
    }
    return self;
}
- (NSString*)title
{
    return _titleLabel.text;
}
- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}
- (UILabel*)iconView
{
    return _iconView;
}

-(void)setIconString:(NSString *)iconString{
    _iconView.text = iconString;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.alpha = (userInteractionEnabled) ? 1 : 0.3;
}


- (void)setSelected:(BOOL)selected
{
    if(selected != _selected){
        _selected = selected;
        if(selected){
            self.backgroundColor = [UIColor lightGrayColor];
        }
        else{
            self.backgroundColor = [UIColor clearColor];
        }
    }
}

@end
