//
//  ImageToolInfo.m
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ImageToolInfo.h"

@implementation ImageToolInfo

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = [dict objectForKey:iconTitle];
//        self.iconImagePath = [dict objectForKey:iconImageName];
        self.mode = [[dict objectForKey:iconMode] integerValue];
        self.iconString = [dict objectForKey:iconfontString];;
    }
    return self;
}

@end
