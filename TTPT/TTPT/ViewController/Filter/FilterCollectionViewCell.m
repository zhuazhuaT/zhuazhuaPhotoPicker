//
//  FilterCollectionViewCell.m
//  TTPT
//
//  Created by guohao on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#define length 60
#define titleheight 20
@implementation FilterCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    float space = (frame.size.width - length)/2;
    self.thumbimv = [[UIImageView alloc] initWithFrame:CGRectMake(space, 5, length, length)];
    [self addSubview:self.thumbimv];
    
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, length + 10, frame.size.width, titleheight)];
    self.titlelabel.backgroundColor = [UIColor clearColor];
    self.titlelabel.textAlignment = NSTextAlignmentCenter;
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
