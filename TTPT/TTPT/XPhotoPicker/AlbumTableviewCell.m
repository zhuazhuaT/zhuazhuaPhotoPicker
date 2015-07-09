//
//  AlbumTableviewCell.m
//  payment
//
//  Created by guohao on 15/7/1.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "AlbumTableviewCell.h"

@implementation AlbumTableviewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // ignore the style argument, use our own to override
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // If you need any further customization
    }
    return self;
}
@end
