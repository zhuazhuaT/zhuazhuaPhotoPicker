//
//  BaseToolsView.h
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnSelectMode)(NSInteger mode);

@interface BaseToolsView : UIScrollView{
    OnSelectMode onSelectModeBlock;
}


-(void)setOnSelectModeBlock:(OnSelectMode)block;
-(void) setToolsArray:(NSArray *)array;
@end
