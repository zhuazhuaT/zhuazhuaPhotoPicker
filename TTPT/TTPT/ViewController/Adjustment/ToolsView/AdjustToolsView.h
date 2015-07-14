//
//  AdjustToolsView.h
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseToolsView.h"
typedef enum {
    Mode_clip = 0,
    Mode_mirror,
    
    Filter_brightness = 10,
    Filter_Saturation,
    Filter_Contrast,
    Filter_Sharpen
}FilterMode;

@interface AdjustToolsView : BaseToolsView


@end
