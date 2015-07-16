//
//  StickerCollectionViewCell.m
//  payment
//
//  Created by guohao on 15/7/8.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "StickerCollectionViewCell.h"

@implementation StickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    
    
    self.imageview = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageview.backgroundColor = [UIColor whiteColor];
    [self.imageview setContentMode:UIViewContentModeScaleAspectFit];
    self.imageview.clipsToBounds = YES;
    self.imageview.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    
    [self addSubview:self.imageview];
    return self;
}


@end
