//
//  FilterViewController.h
//  TTPT
//
//  Created by guohao on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//
#import "DLCGrayscaleContrastFilter.h"
#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "BaseWorkViewController.h"
@interface FilterViewController : BaseWorkViewController{
    UIImageOrientation staticPictureOriginalOrientation;
}
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,strong) GPUImagePicture *staticPicture;
@property (nonatomic,strong) GPUImageView *imageView;
@end
