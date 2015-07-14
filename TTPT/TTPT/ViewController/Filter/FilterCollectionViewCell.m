//
//  FilterCollectionViewCell.m
//  TTPT
//
//  Created by guohao on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#define length 80
#define titleheight 30
@implementation FilterCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    float space = (frame.size.width - length)/2;
    self.thumbimv = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, length, length)];
    [self addSubview:self.thumbimv];
    
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, length + 2*space, frame.size.width, titleheight)];
    [self addSubview:self.titlelabel];
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (!selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.backgroundColor = [UIColor grayColor];
    }
}

@end
