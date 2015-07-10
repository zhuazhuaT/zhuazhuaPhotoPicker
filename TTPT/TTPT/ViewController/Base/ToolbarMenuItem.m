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
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, W-20, W-20)];
        _iconView.clipsToBounds = YES;
        _iconView.layer.cornerRadius = (W - 20)/2;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom + 5, W, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
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
- (UIImageView*)iconView
{
    return _iconView;
}

-(void)setIconImage:(UIImage *)iconImage{
    _iconView.image = iconImage;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.alpha = (userInteractionEnabled) ? 1 : 0.3;
}
- (void)setToolInfo:(ImageToolInfo *)toolInfo
{
    self.title = self.toolInfo.title;
    if(self.toolInfo.iconImagePath){
        self.iconImage = self.toolInfo.iconImage;
    }
    else{
        self.iconImage = nil;
    }
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
