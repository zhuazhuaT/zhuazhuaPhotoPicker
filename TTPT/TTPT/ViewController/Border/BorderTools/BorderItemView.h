//
//  BorderItemView.h
//  TTPT
//
//  Created by bu88 on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BorderItemView;
typedef void (^BorderSelected)(BorderItemView *view,UIImage *image);


@interface BorderItemView : UIView
@property(nonatomic,strong)UIImage * image;//用来传值
@property(nonatomic)BOOL isSelected;//判断是否被选中
@property(nonatomic,strong)UIImageView * stickerImageView;//边框
@property(nonatomic,strong)UIImageView * selectedView;//被选中的imageView

@property(nonatomic,strong) BorderSelected selectBlock;

-(instancetype)initWithFrame:(CGRect)frame Image:(UIImage*)image;
+(instancetype)stickerViewWithFrame:(CGRect)frame Image:(UIImage*)image;
@end
