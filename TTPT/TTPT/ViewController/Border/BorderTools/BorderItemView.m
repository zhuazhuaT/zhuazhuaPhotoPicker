//
//  BorderItemView.m
//  TTPT
//
//  Created by bu88 on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BorderItemView.h"

@implementation BorderItemView
-(UIImageView *)stickerImageView{
    if (!_stickerImageView) {
        _stickerImageView = [[UIImageView alloc]initWithImage:self.image];
        [_stickerImageView setBackgroundColor:[UIColor clearColor]];
    }
    return _stickerImageView;
}

-(UIImageView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_frame_select.png"]];
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
    [self.stickerImageView setFrame:self.bounds];
    [self.selectedView setFrame:self.bounds];
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
