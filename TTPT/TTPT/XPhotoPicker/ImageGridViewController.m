//
//  ImageGridViewController.m
//  payment
//
//  Created by guohao on 15/6/30.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "ImageGridViewController.h"
#import <Photos/Photos.h>
#import "ThumbnailGridCell.h"
#import "SelectPhotoAssets.h"
#define toolbarHeight 50
#define colume 4
#define space  2
#define isIOS8_up [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
static NSString* gridCellId = @"AlbumCellID";

@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end
@implementation UICollectionView (Convenience)
- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
@end

@interface ImageGridViewController()<UICollectionViewDataSource,UICollectionViewDelegate,PHPhotoLibraryChangeObserver>{
    UILabel* countlabel;
    
}
@property (nonatomic,strong) UICollectionView* collectionview;
@property (strong) PHCachingImageManager *imageManager;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@end

@implementation ImageGridViewController
@synthesize maxcount;
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    CGRect rect = self.view.bounds;
    rect.size.height -= toolbarHeight;
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[self collectionViewFlowLayout]];
    [self.collectionview registerClass:[ThumbnailGridCell class] forCellWithReuseIdentifier:gridCellId];
    [self.view addSubview:self.collectionview];
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.contentInset = UIEdgeInsetsMake(space, space, 0, space);
    self.collectionview.allowsMultipleSelection = YES;
    self.imageManager = [PHCachingImageManager new];
    self.selectedAssets = [NSMutableArray new];
    
    [self initBottomBar];
    [self initRightItem];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)initRightItem{
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
}

- (void)initBottomBar{
    float y = [UIScreen mainScreen].bounds.size.height - toolbarHeight;
    float w = [UIScreen mainScreen].bounds.size.width;
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, toolbarHeight)];
    bottomview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bottomview];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomview addSubview:line];
    
    
    UIButton * bt_r = [[UIButton alloc] initWithFrame:CGRectMake(w - 60, 10, 50, 30)];
    [bt_r setTitle:@"确定" forState:UIControlStateNormal];
    [bt_r setTintColor:[UIColor blueColor]];
    [bt_r setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [bt_r addTarget:self action:@selector(onOk) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:bt_r];
    
    
    countlabel = [[UILabel alloc] initWithFrame:CGRectMake((w - 100)/2, 0, 100, toolbarHeight)];
    countlabel.text = @"";
    countlabel.textAlignment = NSTextAlignmentCenter;
    countlabel.textColor = [UIColor lightGrayColor];
    
    [bottomview addSubview:countlabel];
    
}

- (void)clickBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    UICollectionViewFlowLayout* portraitLayout = [[UICollectionViewFlowLayout alloc] init];
    
    portraitLayout.minimumInteritemSpacing = space;
    int cellTotalUsableWidth = [UIScreen mainScreen].bounds.size.width - 5*space;
    portraitLayout.itemSize = CGSizeMake(cellTotalUsableWidth/colume, cellTotalUsableWidth/colume);
    portraitLayout.minimumLineSpacing = space;
    
    return portraitLayout;
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (isIOS8_up) {
        count = self.assetsFetchResults.count;
    }else{
        count = self.assetsArray.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbnailGridCell *cell = [self.collectionview dequeueReusableCellWithReuseIdentifier:gridCellId
                                                                     forIndexPath:indexPath];
    NSInteger currentTag = indexPath.row;
    cell.tag = currentTag;
    
    if (isIOS8_up){
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [self.imageManager requestImageForAsset:asset
                                     targetSize:CGSizeMake(160, 160)
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (cell.tag == currentTag) {
                                          [cell.thumbimv setImage:result];
                                      }
                                  }];
    }else{
      SelectPhotoAssets* asset =   self.assetsArray[indexPath.item];
        [cell.thumbimv setImage:asset.thumbImage];
    }
    return cell;
}


#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedAssets.count >= maxcount) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isIOS8_up) {
        PHAsset* asset = self.assetsFetchResults[indexPath.row];
        [self.selectedAssets addObject:asset];
    }else{
        SelectPhotoAssets* asset =   self.assetsArray[indexPath.item];
        [self.selectedAssets addObject:asset];
    }
    
    
    countlabel.text = [NSString stringWithFormat:@"%ld/%ld",self.selectedAssets.count,maxcount];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isIOS8_up) {
        PHAsset* asset = self.assetsFetchResults[indexPath.row];
        [self.selectedAssets removeObject:asset];
    }else{
        SelectPhotoAssets* asset =   self.assetsArray[indexPath.item];
        [self.selectedAssets removeObject:asset];
    }
    
    countlabel.text = [NSString stringWithFormat:@"%ld/%ld",self.selectedAssets.count,maxcount];
}


- (void)setCancelBlock:(onCancelBlock)block{
    cblock = block;
}

- (void)setFinishBlock:(onFinishBlock)block{
    fblock = block;
}

#pragma mark - outlet 
- (void)onOk{
    if (fblock) {
        NSMutableArray* images = [NSMutableArray new];
        if(isIOS8_up){
            
            for (PHAsset* asset in self.selectedAssets) {
                [self.imageManager requestImageDataForAsset:asset
                                                    options:nil
                                              resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
                 {
                     UIImage *image = [UIImage imageWithData:imageData];
                     
                     [images addObject:image];
                     
                     if (images.count == self.selectedAssets.count) {
                         if (fblock) {
                             fblock(images);
                         }
                     }
                     
                 }];
            }
        }else{
            for (SelectPhotoAssets* asset in self.selectedAssets) {
                [images addObject:asset.originImage];
            }
            
            if (images.count == self.selectedAssets.count) {
                if (fblock) {
                    fblock(images);
                }
            }
        }
            
        
        
        
    }
}

- (void)onCancel{
    if (cblock) {
        cblock();
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // check if there are changes to the assets (insertions, deletions, updates)
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        if (collectionChanges) {
            
            // get the new fetch result
            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
            
            UICollectionView *collectionView = self.collectionview;
            
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
                // we need to reload all if the incremental diffs are not available
                [collectionView reloadData];
                
            } else {
                // if we have incremental diffs, tell the collection view to animate insertions and deletions
                [collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count]) {
                        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:NULL];
            }
            
            [self.imageManager stopCachingImagesForAllAssets];
        }
    });
}

@end
