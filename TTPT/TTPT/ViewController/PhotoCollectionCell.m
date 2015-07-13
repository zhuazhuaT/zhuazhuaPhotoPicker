//
//  PhotoCollectionCell.m
//  TTPT
//
//  Created by bu88 on 15/7/8.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "PhotoCollectionCell.h"

@implementation PhotoCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        isCanLongPress = YES;
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 58, 58)];
        _i_del = [[UIImageView alloc] initWithFrame:CGRectMake(48, 0, 20, 20)];
        _i_del.layer.cornerRadius = 10;
        _i_del.backgroundColor = [UIColor orangeColor];
        _imgBg = [[UIImageView alloc] initWithFrame:_img.frame];
        [_img setClipsToBounds:YES];
        [_img setContentMode:UIViewContentModeScaleAspectFill];
        [_imgBg setBackgroundColor:[UIColor clearColor]];
        _imgBg.layer.borderColor = [UIColor redColor].CGColor;
        _imgBg.layer.borderWidth = 2;
        _imgBg.hidden = YES;
        _i_del.hidden = YES;
//        [_img setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer *pgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [self addGestureRecognizer:pgr];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDel:)];
        [_i_del setUserInteractionEnabled:YES];
        [_i_del addGestureRecognizer:tap];
        [self addSubview:_img];
        [self addSubview:_imgBg];
        [self addSubview:_i_del];
    }
    return self;
}
-(void)setLongPressDisable{
    isCanLongPress = NO;
}
-(void)onLongPress:(UILongPressGestureRecognizer *)sender{
    
    if (_onLongPress&&isCanLongPress) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            _onLongPress(_position);
        }
        
    }
}
-(void)onClickDel:(UITapGestureRecognizer *)sender{
    if (_onClickDel) {
        _onClickDel(_position);
    }
}
@end
