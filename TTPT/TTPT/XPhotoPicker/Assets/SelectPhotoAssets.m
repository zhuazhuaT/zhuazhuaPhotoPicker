//
//  SelectPhotoAssets.m
//  PhotoPicker
//
//  Created by bu88 on 15/7/6.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "SelectPhotoAssets.h"

@implementation SelectPhotoAssets : NSObject

- (UIImage *)thumbImage{
    return [UIImage imageWithCGImage:[self.asset thumbnail]];
}

- (UIImage *)originImage{
    return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
}

- (BOOL)isVideoType{
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}


@end
