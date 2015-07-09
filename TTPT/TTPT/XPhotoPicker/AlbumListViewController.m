//
//  AlbumListViewController.m
//  payment
//
//  Created by guohao on 15/6/30.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "AlbumListViewController.h"
#import <ImageIO/ImageIO.h>
@import Photos;
#import "SelectPhotoPickerDatas.h"
#import "AlbumTableviewCell.h"
#import "ImageGridViewController.h"
#import "SelectPhotoPickerGroup.h"
#import "SelectPhotoAssets.h"

#define isIOS8_up [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
NS_ENUM(NSInteger, VOKAlbumDataSourceType) {
    VOKAlbumDataSourceTypeAlbums = 0,
    VOKAlbumDataSourceTypeTopLevelUserCollections,
    
    VOKAlbumDataSourceTypeCount
};

static NSString* albumCellID = @"AlbumCellID";
@interface AlbumListViewController() <UITableViewDataSource, UITableViewDelegate,PHPhotoLibraryChangeObserver>{
    PHAssetMediaType mediatype;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) PHFetchResult *phFetchResult;
@property (nonatomic, strong) PHAssetCollection *phAssetCollection;
@property (nonatomic) NSArray *collectionFetchResults;

@end

@implementation AlbumListViewController

- (instancetype)init{
    self = [super init];
    
    mediatype = PHAssetMediaTypeImage;
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [tableView registerClass:[AlbumTableviewCell class] forCellReuseIdentifier:albumCellID];
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    if (isIOS8_up) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                 subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                 options:nil];
                
                //Fetch top level user collections
                PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
                NSLog(@"album %ld",albums.count);
                _collectionFetchResults = @[albums, topLevelUserCollections];
                
                [self updateCollectionArrays];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
                
                [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
            } else {
                //TODO: Handle no access.
            }
        }];
    }else{
        //[self getImgs];
    }
    
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"相册";
    [self initRightItem];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)initRightItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
}

- (void)updateCollectionArrays
{
    PHFetchResult *albums = self.collectionFetchResults[VOKAlbumDataSourceTypeAlbums];
    NSMutableArray *albumsWithAssetsArray = [NSMutableArray arrayWithCapacity:albums.count];
    [albums enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsInCollection = [self vok_fetchResultWithAssetCollection:obj mediaType:mediatype];
        if (assetsInCollection.count > 0 && assetsInCollection.count < NSNotFound) {
            [albumsWithAssetsArray addObject:obj];
        }
    }];
    
    PHFetchResult *topLevelUserCollections = self.collectionFetchResults[VOKAlbumDataSourceTypeTopLevelUserCollections];
    NSMutableArray *topLevelUserCollectionsWithAssetsArray = [NSMutableArray arrayWithCapacity:topLevelUserCollections.count];
    [topLevelUserCollectionsWithAssetsArray enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsInCollection = [self vok_fetchResultWithAssetCollection:obj mediaType:mediatype];
        if (assetsInCollection.count > 0 && assetsInCollection.count < NSNotFound) {
            [topLevelUserCollectionsWithAssetsArray addObject:obj];
        }
    }];
    NSLog(@"albums-%ld,other-%ld",albumsWithAssetsArray.count,topLevelUserCollectionsWithAssetsArray.count);
    self.collectionArrays = @[albumsWithAssetsArray, topLevelUserCollectionsWithAssetsArray];
}

- (PHFetchResult *)vok_fetchResultWithAssetCollection:(PHAssetCollection *)assetCollection mediaType:(PHAssetMediaType)type{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    
    if (type != PHAssetMediaTypeUnknown) {
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %@", @(type)];
    }
    
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isIOS8_up) {
        PHFetchResult *fetchResult = self.collectionArrays[section];
        NSLog(@"----%ld",fetchResult.count);
        return fetchResult.count;
    }else{
        return self.collectionArrays.count;
    }
    
}

- (PHAssetCollection *)assetCollectionForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *fetchResults = self.collectionArrays[indexPath.section];
    return fetchResults[indexPath.row];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumTableviewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:albumCellID forIndexPath:indexPath];
    cell.imageView.image = nil;
    if (isIOS8_up) {
        PHAssetCollection *collection = [self assetCollectionForIndexPath:indexPath];
        
        //Get last image
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assets.lastObject) {
            PHAsset *asset = assets.lastObject;
            
            PHImageRequestOptions* option = [[PHImageRequestOptions alloc] init];
            option.resizeMode = PHImageRequestOptionsResizeModeExact;
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:CGSizeMake(140, 140)
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:option
                                                    resultHandler:^(UIImage *result, NSDictionary *info) {
                                                        cell.imageView.image = result;
                                                        [cell layoutSubviews];
                                                    }];
        }
        
        //Get album name
        cell.textLabel.text = collection.localizedTitle;
        NSLog(@"%@",collection.localizedTitle);
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        if (assetsFetchResult.count == NSNotFound) {
            cell.detailTextLabel.text = nil;
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", assetsFetchResult.count];
        }
        
    }else{
        SelectPhotoPickerGroup* group = self.collectionArrays[indexPath.row];
        cell.imageView.image = group.thumbImage;
        cell.textLabel.text = group.groupName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld)",group.assetsCount];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageGridViewController* igvc = [[ImageGridViewController alloc] init];
    igvc.maxcount = self.maxcount;
    if (isIOS8_up) {
        PHAssetCollection *collection = [self assetCollectionForIndexPath:indexPath];
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.sortDescriptors = @[[self vok_creationDateSortDescriptor]];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
        igvc.assetsFetchResults = assetsFetchResult;
        
        [igvc setFinishBlock:^(NSArray *selectedAssets) {
            [self onFinish:selectedAssets];
        }];
        
        [igvc setCancelBlock:^{
            [self onCancel];
        }];
        [self.navigationController pushViewController:igvc animated:YES];
    }else{
        SelectPhotoPickerGroup* group = self.collectionArrays[indexPath.row];
        
        __block NSMutableArray* assetsM = [NSMutableArray new];
        
        [[SelectPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:group finished:^(NSArray *assets) {
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                SelectPhotoAssets *zlAsset = [[SelectPhotoAssets alloc] init];
                zlAsset.asset = asset;
                [assetsM addObject:zlAsset];
            }];
            
            igvc.assetsArray = assetsM;
            
            [igvc setCancelBlock:^{
                [self onCancel];
            }];
            
            [igvc setFinishBlock:^(NSArray *selectedAssets) {
                [self onFinish:selectedAssets];
            }];
            [self.navigationController pushViewController:igvc animated:YES];
            
        }];
        
    }
    
    
    
    
}

- (NSSortDescriptor*)vok_creationDateSortDescriptor{
    return [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
}

- (void)setCancelBlock:(onCancelBlock)block{
    cblcok = block;
}

- (void)setFinishBlock:(onFinishBlock)block{
    fblock = block;
}

- (void)onCancel{
    if (cblcok) {
        cblcok();
    }
}

- (void)onFinish:(NSArray*)selectarray{
    if (fblock) {
        fblock(selectarray);
    }
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        
        for (PHFetchResult *collectionsFetchResult in self.collectionFetchResults) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails) {
                if (!updatedCollectionsFetchResults) {
                    updatedCollectionsFetchResults = [self.collectionFetchResults mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self.collectionFetchResults indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        
        //This only affects to changes in albums level (add/remove/edit album)
        if (updatedCollectionsFetchResults)
        {
            self.collectionFetchResults = updatedCollectionsFetchResults;
        }
        
        [self updateCollectionArrays];
        [self.tableView reloadData];
        
    });
}

#pragma mark - mark IOS7
-(void)getImgs{
    SelectPhotoPickerDatas *datas = [SelectPhotoPickerDatas defaultPicker];
    
    __weak typeof(self) weakSelf = self;
    
    [datas getAllGroupWithPhotos:^(NSArray *groups) {
        self.collectionArrays = groups;
        
        weakSelf.tableView.dataSource = self;
        [weakSelf.tableView reloadData];
        
    }];
}

@end
