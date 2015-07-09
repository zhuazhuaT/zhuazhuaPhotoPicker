//
//  ThumbnailGridCell.m
//  payment
//
//  Created by guohao on 15/7/2.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "ThumbnailGridCell.h"

@implementation ThumbnailGridCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.thumbimv = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.thumbimv];
    self.thumbimv.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbimv.clipsToBounds = YES;
    
    float x = self.bounds.size.width - 22;
    self.checkmark = [[SSCheckMark alloc] initWithFrame:CGRectMake(x, 0, 22, 22)];
    [self.checkmark setChecked:NO];
    self.checkmark.backgroundColor = [UIColor clearColor];
    [self addSubview:self.checkmark];
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self.checkmark setChecked:selected];
}



@end
