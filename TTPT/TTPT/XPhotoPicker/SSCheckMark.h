//
//  SSCheckMark.h
//  payment
//
//  Created by guohao on 15/7/4.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM( NSUInteger, SSCheckMarkStyle )
{
    SSCheckMarkStyleOpenCircle,
    SSCheckMarkStyleGrayedOut
};

@interface SSCheckMark : UIView

@property (readwrite) bool checked;
@property (readwrite) SSCheckMarkStyle checkMarkStyle;

@end