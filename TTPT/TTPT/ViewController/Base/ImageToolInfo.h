//
//  ImageToolInfo.h
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define iconTitle           @"title"
#define iconImageName   @"iconimage"
#define iconMode        @"iconMode"

@interface ImageToolInfo : NSObject
@property (nonatomic, strong)   NSString *title;
@property (nonatomic, strong)   NSString *iconImagePath;
@property (nonatomic, strong) UIImage  *iconImage;
@property (assign) NSInteger mode;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
