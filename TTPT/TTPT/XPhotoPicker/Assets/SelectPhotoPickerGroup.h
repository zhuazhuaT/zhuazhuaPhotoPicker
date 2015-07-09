//
//  SelectPhotoPickerGroup.h
//  PhotoPicker
//
//  Created by bu88 on 15/7/6.
//  Copyright (c) 2015年 Quan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SelectPhotoPickerGroup : NSObject
/**
 *  组名
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  组的真实名
 */
@property (nonatomic , copy) NSString *realGroupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) ALAssetsGroup *group;
@end
