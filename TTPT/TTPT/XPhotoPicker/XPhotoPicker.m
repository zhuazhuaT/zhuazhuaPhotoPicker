//
//  _PhotoPicker.m
//  ΩPhotoPicker
//
//  Created by guohao on 15/7/3.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "XPhotoPicker.h"
#import "SelectPhotoPickerGroup.h"
#import "SelectPhotoPickerDatas.h"
#import "AlbumListViewController.h"
#import "ImageGridViewController.h"
#import "SelectPhotoAssets.h"
@implementation XPhotoPicker
- (instancetype)initWithViewController:(UIViewController*)vc
    onOK:(onFinishPickerBlock)okblock
    onCancel:(onCancelPickerBlock)cancelblock{
    self = [super init];
    self.viewcontroller = vc;
    cblock = cancelblock;
    fblock = okblock;
    self.maxCount = 9;
    return self;
}

- (void)show{
    if(self.viewcontroller){
        
        AlbumListViewController * avc = [AlbumListViewController new];
        avc.maxcount = self.maxCount;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:avc];
        [avc setCancelBlock:^{
            [nav dismissViewControllerAnimated:YES completion:nil];
            if(cblock){
                cblock();
            }
        }];
        
        [avc setFinishBlock:^(NSArray *selectedAssets) {
            [nav dismissViewControllerAnimated:YES completion:nil];
            if(fblock){
                
                fblock(selectedAssets);
            }
        }];
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            // default level2 grid
            
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO],];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
            
            ImageGridViewController* igv = [ImageGridViewController new];
            igv.maxcount = self.maxCount;
            [igv setFinishBlock:^(NSArray *selectedAssets) {
                [nav dismissViewControllerAnimated:YES completion:nil];
                if(fblock){
                    fblock(selectedAssets);
                }
            }];
            [igv setCancelBlock:^{
                [nav dismissViewControllerAnimated:YES completion:nil];
                if(cblock){
                    cblock();
                }
            }];
            igv.assetsFetchResults = fetchResult;
            
            [self.viewcontroller presentViewController:nav animated:YES completion:nil];
            nav.viewControllers = @[avc,igv];
            
        }else{
            
            
            
            SelectPhotoPickerDatas *datas = [SelectPhotoPickerDatas defaultPicker];
            
            [datas getAllGroupWithPhotos:^(NSArray *groups) {
                avc.collectionArrays = groups;
                
                SelectPhotoPickerGroup *gp = nil;
                for (SelectPhotoPickerGroup *group in groups) {
                    if (([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"])) {
                        gp = group;
                        break;
                    }else if (([group.groupName isEqualToString:@"Saved Photos"] || [group.groupName isEqualToString:@"保存相册"])){
                        gp = group;
                        break;
                    }else if (([group.groupName isEqualToString:@"Stream"] || [group.groupName isEqualToString:@"我的照片流"])){
                        gp = group;
                        break;
                    }
                }
                
                __block NSMutableArray *assetsM = [NSMutableArray new];
                
                [[SelectPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:gp finished:^(NSArray *assets) {
                    [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                        SelectPhotoAssets *zlAsset = [[SelectPhotoAssets alloc] init];
                        zlAsset.asset = asset;
                        [assetsM addObject:zlAsset];
                    }];
                    
                    ImageGridViewController* igv = [ImageGridViewController new];
                    igv.maxcount = self.maxCount;
                    [igv setFinishBlock:^(NSArray *selectedAssets) {
                        [nav dismissViewControllerAnimated:YES completion:nil];
                        if(fblock){
                            fblock(selectedAssets);
                        }
                    }];
                    [igv setCancelBlock:^{
                        [nav dismissViewControllerAnimated:YES completion:nil];
                        if(cblock){
                            cblock();
                        }
                    }];
                    igv.assetsArray = assetsM;
                    
                    [self.viewcontroller presentViewController:nav animated:YES completion:nil];
                    nav.viewControllers = @[avc,igv];
                   
                }];
                
            }];
            
            
        }
        
        
        
        
        
        
        
    }
}



@end
