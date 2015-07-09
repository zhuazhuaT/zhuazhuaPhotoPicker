//
//  ImageGridViewController.h
//  payment
//
//  Created by guohao on 15/6/30.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFetchResult;

typedef void (^onCancelSelectPhotoBlock)(void);
typedef void (^onFinishSelectPhotoBlock)(NSArray* selectedAssets);

@interface ImageGridViewController : UIViewController{
    onCancelSelectPhotoBlock cblock;
    onFinishSelectPhotoBlock fblock;
}
@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) NSMutableArray *assetsArray;
@property (nonatomic) NSInteger maxcount;
- (void)setCancelBlock:(onCancelSelectPhotoBlock)blcok;
- (void)setFinishBlock:(onFinishSelectPhotoBlock)block;
@end
