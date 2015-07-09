//
//  ImageGridViewController.h
//  payment
//
//  Created by guohao on 15/6/30.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFetchResult;

typedef void (^onCancelBlock)(void);
typedef void (^onFinishBlock)(NSArray* selectedAssets);

@interface ImageGridViewController : UIViewController{
    onCancelBlock cblock;
    onFinishBlock fblock;
}
@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) NSMutableArray *assetsArray;
@property (nonatomic) NSInteger maxcount;
- (void)setCancelBlock:(onCancelBlock)blcok;
- (void)setFinishBlock:(onFinishBlock)block;
@end
