//
//  BaseToolsView.m
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BaseToolsView.h"

@implementation BaseToolsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

-(void) setToolsArray:(NSArray *)array{
    
}

-(void)setOnSelectModeBlock:(OnSelectMode)block{
    onSelectModeBlock  =block;
}

@end
