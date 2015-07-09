//
//  AlbumListViewController.h
//  payment
//
//  Created by guohao on 15/6/30.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onCancelBlock)(void);
typedef void (^onFinishBlock)(NSArray* selectedAssets);
@interface AlbumListViewController : UIViewController{
    onCancelBlock cblcok;
    onFinishBlock fblock;
}
@property (nonatomic) NSArray *collectionArrays;
@property (nonatomic) NSInteger maxcount;
- (void)setCancelBlock:(onCancelBlock)block;
- (void)setFinishBlock:(onFinishBlock)block;
@end
