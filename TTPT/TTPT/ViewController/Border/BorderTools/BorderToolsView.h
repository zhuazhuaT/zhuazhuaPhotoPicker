//
//  BorderToolsView.h
//  TTPT
//
//  Created by bu88 on 15/7/11.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BaseToolsView.h"
#import "BorderItemView.h"
#define STICKERITEM_WIDTH 100
#define STICKERITEM_HEIGHT 100
typedef void (^SelectBorder)(UIImage *image,UIEdgeInsets insert);
@interface BorderToolsView : BaseToolsView


@property(nonatomic,strong) SelectBorder selectBlock;

@end