//
//  BorderItemView.m
//  TTPT
//
//  Created by bu88 on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BorderItemView.h"
#import "UIView+Frame.h"
@implementation BorderItemView
-(UIImageView *)stickerImageView{
    if (!_stickerImageView) {
        _stickerImageView = [[UIImageView alloc]initWithImage:self.image];
        [_stickerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_stickerImageView setBackgroundColor:[UIColor clearColor]];
    }
    return _stickerImageView;
}

-(UIImageView *)selectedView{
    if (!_selectedView) {
        CGFloat top =30; // 顶端盖高度
        CGFloat bottom = 30; // 底端盖高度
        CGFloat left = 30; // 左端盖宽度
        CGFloat right = 30; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *img = [[UIImage imageNamed:@"icon_frame_select.png"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        _selectedView = [[UIImageView alloc]initWithImage:img];
        [_selectedView setBackgroundColor:[UIColor clearColor]];
    }
    return _selectedView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.stickerImageView];
    [self addSubview:self.selectedView];
}

-(void)layoutSubviews{
    float w = self.width;
    float h = self.height;
    float space = 8;
    
    [self.stickerImageView setFrame:CGRectMake(space, space, w - space*2, h - space*2)];
    [self.selectedView setFrame:self.stickerImageView.frame];
    if (self.isSelected) {
        [self.selectedView setHidden:NO];
    }else{
        [self.selectedView setHidden:YES];
    }
}

-(instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:image];
        [self initUI];
    }
    return self;
}

+(instancetype)stickerViewWithFrame:(CGRect)frame Image:(UIImage *)image{
    return [[BorderItemView alloc]initWithFrame:frame Image:image];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self setIsSelected:!self.isSelected];
    if (self.isSelected) {
        [self.selectedView setHidden:NO];
    }else{
        [self.selectedView setHidden:YES];
    }
    
    if (self.selectBlock) {
        self.selectBlock(self, self.image);
    }
}


@end
