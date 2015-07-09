//
//  PhotoCollectionCell.h
//  TTPT
//
//  Created by bu88 on 15/7/8.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OnLongPress)(int position);
typedef void (^OnClickDel)(int position);
@interface PhotoCollectionCell : UICollectionViewCell{
    BOOL isCanLongPress;
}
@property (assign) int position;
@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UIView *imgBg;
@property (strong, nonatomic) UIImageView *i_del;
@property (strong, nonatomic) UIImageView *i_finish;
@property (strong, nonatomic) OnLongPress onLongPress;
@property (strong, nonatomic) OnClickDel onClickDel;

-(void)setLongPressDisable;

@end
