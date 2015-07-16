//
//  CropViewController.h
//  TTPT
//
//  Created by bu88 on 15/7/15.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWorkViewController.h"
//@protocol ImageCropDelegate <NSObject>
//
//- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;
//
//@end

typedef void (^CropImage)(UIImage *image);

@interface CropViewController : BaseWorkViewController{
//    CropImage cropImageBlock;
}

//-(void)setCropImageBlock:(CropImage) block;


//下面俩哪个后面设置，即是哪个有效
//@property(nonatomic,strong) UIImage *image;

@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比

@end
