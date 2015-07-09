//
//  SelectPhotoPickerDatas.h
//  PhotoPicker
//
//  Created by bu88 on 15/7/6.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SelectPhotoPickerGroup;

// 回调
typedef void(^callBackBlock)(id obj);

@interface SelectPhotoPickerDatas : NSObject

/**
 *  获取所有组
 */
+ (instancetype) defaultPicker;

/**
 * 获取所有组对应的图片
 */
- (void) getAllGroupWithPhotos : (callBackBlock ) callBack;

/**
 * 获取所有组对应的Videos
 */
- (void) getAllGroupWithVideos : (callBackBlock ) callBack;

/**
 *  传入一个组获取组里面的Asset
 */
- (void) getGroupPhotosWithGroup : (SelectPhotoPickerGroup *) pickerGroup finished : (callBackBlock ) callBack;

/**
 *  传入一个AssetsURL来获取UIImage
 */
- (void) getAssetsPhotoWithURLs:(NSURL *) url callBack:(callBackBlock ) callBack;

@end
