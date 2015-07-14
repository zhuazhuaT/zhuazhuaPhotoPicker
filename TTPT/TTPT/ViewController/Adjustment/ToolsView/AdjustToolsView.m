//
//  AdjustToolsView.m
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "AdjustToolsView.h"
#import "ToolbarMenuItem.h"
#import "UIView+Frame.h"
#import "ImageToolInfo.h"
static const CGFloat kCLImageToolAnimationDuration = 0.3;
@implementation AdjustToolsView{
    NSArray *array;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        array = [NSArray arrayWithObjects:
  @{iconMode: [NSNumber numberWithInt:Mode_clip],iconTitle:@"裁剪",iconfontString:@""},
  @{iconMode: [NSNumber numberWithInt:Mode_mirror],iconTitle:@"镜像",iconfontString:@""},

  @{iconMode: [NSNumber numberWithInt:Filter_brightness],iconTitle:@"亮度",iconfontString:@""},
  @{iconMode: [NSNumber numberWithInt:Filter_Sharpen],iconTitle:@"锐度",iconfontString:@""},
  @{iconMode: [NSNumber numberWithInt:Filter_Contrast],iconTitle:@"对比度",iconfontString:@""}, nil];
        
        [self show];
        
        
    }
    return self;
}

-(void)show{
    CGFloat x = 0;
    CGFloat W = 80;
    CGFloat H = self.height;
    
    NSInteger toolCount = array.count;
    CGFloat padding = 10;
//    CGFloat diff = self.frame.size.width - toolCount * W;
//    if (0<diff && diff<2*W) {
//        padding = diff/(toolCount+1);
//    }
    
    for (int i =0; i<toolCount; i++) {
        ToolbarMenuItem *item = [[ToolbarMenuItem alloc] initWithFrame:CGRectMake(x+padding, 0, W, H)  target:self action:@selector(tappedMenuView:) toolInfo:[[ImageToolInfo alloc] initWithDict:array[i]]];
//        item.backgroundColor = [UIColor blueColor];
        [self addSubview:item];
        x += W+padding;
    }
     self.contentSize = CGSizeMake(MAX(x, self.frame.size.width+1)+padding, 0);
}
- (void)tappedMenuView:(UITapGestureRecognizer*)sender
{
    ToolbarMenuItem *view = (ToolbarMenuItem *)sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    if (onSelectModeBlock) {
        onSelectModeBlock(view.toolInfo.mode);
    }
}
@end
