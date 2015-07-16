//
//  BorderToolsView.m
//  TTPT
//
//  Created by bu88 on 15/7/11.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BorderToolsView.h"
#define FRAME_COUNT    25



@implementation BorderToolsView{
    NSMutableArray *frameImagearray;
    NSMutableArray *frameBigImagearray;
    NSArray *insertArrays;
}



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
 //       NSString * path = [[NSBundle mainBundle]resourcePath];
 //       NSFileManager * fm = [NSFileManager defaultManager];
        frameImagearray = [[NSMutableArray alloc]init];
        frameBigImagearray = [[NSMutableArray alloc]init];
        NSString * insertStr = [[NSBundle mainBundle]pathForResource:@"framePlist" ofType:@"plist"];
        insertArrays = [[NSArray alloc]initWithContentsOfFile:insertStr];
        
 //       NSArray * array = [fm contentsOfDirectoryAtPath:path error:nil];
        for (int i=0;i<FRAME_COUNT;i++) {
            NSString *fileNames = [NSString stringWithFormat:@"s_%d",i];
            [frameImagearray addObject:[UIImage imageNamed:fileNames]];
            
            NSString *fileNameb =[NSString stringWithFormat:@"i_%d",i];
            [frameBigImagearray addObject:[UIImage imageNamed:fileNameb]];
            
        }
        for (int i = 0; i < FRAME_COUNT; i ++) {
            BorderItemView * sticker = [BorderItemView stickerViewWithFrame:CGRectMake(STICKERITEM_WIDTH * i,0, STICKERITEM_WIDTH, STICKERITEM_HEIGHT) Image:frameImagearray[i]];
            [sticker setSelectBlock:^(BorderItemView *view,UIImage *image){
                [self changeSelfView:view image:image];
            }];
            [self addSubview:sticker];
        }
        [self setContentSize:CGSizeMake(FRAME_COUNT * STICKERITEM_WIDTH, STICKERITEM_HEIGHT)];
    }
    return self;
}

-(void)changeSelfView:(BorderItemView *)view image:(UIImage *)image{
    NSInteger index = [[self subviews] indexOfObject:view];
    UIImage * stickerImage;
    UIEdgeInsets uii;

    if (index == -1) {
        stickerImage = [UIImage imageNamed:@""];
    }else{
        NSArray *sub = insertArrays[index];
        CGFloat top = [sub[0] floatValue]/2; // 顶端盖高度
        CGFloat bottom = [sub[1] floatValue]/2; // 底端盖高度
        CGFloat left = [sub[2] floatValue]/2; // 左端盖宽度
        CGFloat right = [sub[3] floatValue]/2; // 右端盖宽度
        uii = UIEdgeInsetsMake(top, left, bottom,right);
        stickerImage = frameBigImagearray[index];
        
        
    }
    for (BorderItemView * sticker in self.subviews) {
        if ([sticker isEqual:view]) {
            if (self.selectBlock) {
                
                if (view.isSelected) {
                    
                    self.selectBlock(stickerImage,uii);
                }else{
                    uii = UIEdgeInsetsMake(0, 0, 0, 0);
                    self.selectBlock(nil,uii);
                }
            }
            
        }else{
            if([sticker isKindOfClass:[BorderItemView class]]){
                [sticker setIsSelected:NO];
                [sticker.selectedView setHidden:YES];
            }
        }
    }
}

@end
