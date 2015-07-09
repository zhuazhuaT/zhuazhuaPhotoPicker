//
//  ZZEditPhotoViewController.h
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBorderPickViewController.h"
#import "ZZPasterPickViewController.h"
#import "ZZEditSelectItemView.h"
typedef void  (^ReturnEditedPhotos)(NSArray *photoArray);
@interface ZZEditPhotoViewController : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong, nonatomic) UIImage *currentImage;//当前编辑的视图
@property(strong, nonatomic) NSMutableArray *photoArray;//要编辑的图片数组
@property(strong, nonatomic) UIView *prePhotoView;//顶部的视图--包括

@property(nonatomic,strong)UIView * editView;//编辑视图
@property(nonatomic,strong)UIImageView * imageView;//编辑图ImageView

@property(nonatomic,strong)UIImageView * imageSticker;//边框
@property(nonatomic,strong)ZZEditSelectItemView * editSelectItem;//选项卡

@property(nonatomic)NSInteger selectedItemIndex;//选择的

@property(nonatomic,strong)NSArray * buttonImages;//选项卡按钮图片 二维数组

@property(nonatomic, strong) UICollectionView *editPhotosView;
@property (nonatomic, strong) ReturnEditedPhotos editedPhotoBlock;
@property(nonatomic)BOOL isFrames;
@property(nonatomic)BOOL isEffect;
@property(nonatomic)BOOL isMark;

-(void)setMyPhotoArray:(NSArray *)photoArray;

@end
