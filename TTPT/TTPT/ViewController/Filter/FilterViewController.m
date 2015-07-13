//
//  FilterViewController.m
//  TTPT
//
//  Created by guohao on 15/7/13.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCollectionViewCell.h"
#import "GPUImage.h"

#define space 5
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define cellid @"filterCellID"

@interface FilterUnit : NSObject
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) UIImage* image;
@end

@implementation FilterUnit
@end

@interface FilterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView* collectionview;

@property (nonatomic,strong) NSArray* acv_array;
@property (nonatomic,strong) NSMutableArray* filterUnitArray;
@end

@implementation FilterViewController
@synthesize filter,acv_array,filterUnitArray,staticPicture;
- (void)viewDidLoad {
    
    filter = [[GPUImageFilter alloc] init];
    acv_array = @[@"crossprocess",@"02",@"17",@"aqua",@"yellow-red",@"06",@"purple-green"];
    NSInteger count = acv_array.count+3;
    
    filterUnitArray = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        FilterUnit* funit = [FilterUnit new];
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        funit.image = image;
        funit.title = [NSString stringWithFormat:@"title %d",i+1];
        [filterUnitArray addObject:funit];
    }
    
    
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    self.imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    
    staticPicture = [[GPUImagePicture alloc] initWithImage:self.originalImage smoothlyScaleOutput:YES];
   
    
    [self.view addSubview:self.imageView];
    
    [self initFilterCollectionview];
    [super viewDidLoad];
}

- (void)initFilterCollectionview{
    float y = self.view.bounds.size.height;
    float w = self.view.bounds.size.width;
    float h_tool = 50;
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y - bottom_height-h_tool, w, h_tool) collectionViewLayout:[self collectionViewFlowLayout]];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    [self.view addSubview:self.collectionview];
}

#pragma mark - UICollection delegate

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    UICollectionViewFlowLayout* portraitLayout = [[UICollectionViewFlowLayout alloc] init];
    
    portraitLayout.minimumInteritemSpacing = space;
    portraitLayout.itemSize = CGSizeMake(40, 40);
    portraitLayout.minimumLineSpacing = space;
    portraitLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return portraitLayout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return filterUnitArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterCollectionViewCell* cell = [self.collectionview dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    FilterUnit* unit = self.filterUnitArray[indexPath.row];
    cell.thumbimv.image = unit.image;
    cell.titlelabel.text = unit.title;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger n = indexPath.row;
    [self onFilter:n];
}

- (void)onFilter:(NSInteger)n{
    [self removeAllTargets];
    [self setFilterType:n];
    [self prepareStaticFilter];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareStaticFilter];
}

-(void) setFilterType:(NSInteger) index {
    switch (index) {
        case 1:{
            filter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter *) filter setContrast:1.75];
        } break;
        case 2: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
        } break;
        case 3: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
        } break;
        case 4: {
            filter = [[DLCGrayscaleContrastFilter alloc] init];
        } break;
        case 5: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
        } break;
        case 6: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
        } break;
        case 7: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
        } break;
        case 8: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
        } break;
        case 9: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
        } break;
        default:
            filter = [[GPUImageFilter alloc] init];
            break;
    }
}

-(void) removeAllTargets {
    [staticPicture removeAllTargets];
    //regular filter
    [filter removeAllTargets];
}

-(void) prepareStaticFilter {
    
    [staticPicture addTarget:filter];
    
   [filter addTarget:self.imageView];
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageNoRotation;
    switch (staticPictureOriginalOrientation) {
        case UIImageOrientationLeft:
            imageViewRotationMode = kGPUImageRotateLeft;
            break;
        case UIImageOrientationRight:
            imageViewRotationMode = kGPUImageRotateRight;
            break;
        case UIImageOrientationDown:
            imageViewRotationMode = kGPUImageRotate180;
            break;
        default:
            imageViewRotationMode = kGPUImageNoRotation;
            break;
    }
    
    // seems like atIndex is ignored by GPUImageView...
    [self.imageView setInputRotation:imageViewRotationMode atIndex:0];
    
    
    [staticPicture processImage];
    
  
}

- (void)onClickFinish:(id)sender{
    if (fblock) {
        fblock([filter   imageByFilteringImage:self.originalImage]);
    }
    
}

@end
