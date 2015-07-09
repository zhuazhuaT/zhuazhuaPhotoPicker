//
//  AlbumListViewController.h
//  payment
//
//  Created by guohao on 15/6/30.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onCancelAlbumBlock)(void);
typedef void (^onFinishAlbumBlock)(NSArray* selectedAssets);
@interface AlbumListViewController : UIViewController{
    onCancelAlbumBlock cblcok;
    onFinishAlbumBlock fblock;
}
@property (nonatomic) NSArray *collectionArrays;
@property (nonatomic) NSInteger maxcount;
- (void)setCancelBlock:(onCancelAlbumBlock)block;
- (void)setFinishBlock:(onFinishAlbumBlock)block;
@end
