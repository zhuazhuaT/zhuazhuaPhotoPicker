//
//  ZZEditPhotoViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "PhotoCollectionCell.h"
#import "XPhotoPicker.h"
#import "StickerViewController.h"
#import "StickerEditViewController.h"
#import "AdjustmentViewController.h"
//#import "ClipViewController.h"
#import "FilterViewController.h"
#import "RotateViewController.h"
#import "CropViewController.h"
#define TOP_HEIGHT  70
#define MAX_COUNT  9
#define ADJUSTMENT_HEIGHT 80
#define BOTTOM_HEIGHT    70
@implementation EditPhotoViewController{
    NSMutableArray *selectArray;
    NSMutableArray *delArray;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        selectArray = [NSMutableArray new];
        delArray = [NSMutableArray new];
        if (!_photoArray) {
            _photoArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(UICollectionView *)editPhotosView{
    if (!_editPhotosView) {
        
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _editPhotosView = [[UICollectionView alloc] initWithFrame:CGRectMake(5+30+5, 0, self.view.frame.size.width - 40 - 60-10, 64) collectionViewLayout:layout];
        [_editPhotosView setBackgroundColor:[UIColor clearColor]];
        [_editPhotosView setShowsHorizontalScrollIndicator:NO];
        [_editPhotosView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:@"GradientCell"];
        _editPhotosView.delegate = self;
        _editPhotosView.dataSource = self;
    }
    return _editPhotosView;
}

-(AdjustToolsView *)adjustView{
    if (!_adjustView) {
        _adjustView = [[AdjustToolsView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 0, self.view.bounds.size.width,ADJUSTMENT_HEIGHT)];
//        [self downEffect];
        [_adjustView setOnSelectModeBlock:^(NSInteger mode) {
            self.isEffect = !self.isEffect;
            [self downEffect];
            if ( mode==Mode_mirror) {
                
                [self onRotate];
            }else if(mode == Mode_clip){
                [self onClip];
            }else if (mode>=Filter_brightness) {
                AdjustmentViewController *avc = [[AdjustmentViewController alloc] initWithImage:[self.photoArray objectAtIndex:self.currentPosition] withType:mode];
                [avc setFinish:^(UIImage *image) {
                    [self.photoArray replaceObjectAtIndex:self.currentPosition withObject:image];
                    //            self.currentImage = image;
                    self.imageView.image = [self.photoArray objectAtIndex:self.currentPosition];
                    [self.editPhotosView reloadData];
                } Cancel:^{
                    
                }];
                [self.navigationController pushViewController:avc animated:NO];
            }
            
        }];
    }
    return _adjustView;
}

-(NSArray *)buttonImages{
    if(!_buttonImages)_buttonImages = @[@[[UIImage imageNamed:@"edit_frame.png"],[UIImage imageNamed:@"edit_frame_h.png"]],@[[UIImage imageNamed:@"edit_lomo.png"],[UIImage imageNamed:@"edit_lomo_h.png"]],@[[UIImage imageNamed:@"edit_paint.png"],[UIImage imageNamed:@"edit_paint_h.png"]]];
    return _buttonImages;
}

-(EditSelectItemView *)editSelectItem{
    if(!_editSelectItem){
        _editSelectItem = [[EditSelectItemView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - BOTTOM_HEIGHT, self.view.bounds.size.width,BOTTOM_HEIGHT)];
        [_editSelectItem setOnClickButtonBlock:^(NSInteger position) {
            [self selectButton:position];
        }];
    }
    return _editSelectItem;
}

-(UIView *)editView{//编辑视图
    if(!_editView){
        _editView = [[UIView alloc]init];
        [_editView.layer setBorderWidth:2.0];
        [_editView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
//        [_editView.layer setCornerRadius:10.0];
        [_editView.layer setMasksToBounds:YES];
        [_editView addSubview:self.imageView];
        [_editView addSubview:self.imageSticker];
    }
    return _editView;
}

-(UIImageView *)imageView{//编辑中的图Imageview
    if(!_imageView){
        _imageView = [[UIImageView alloc]init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [_imageView.layer setBorderWidth:2.0];
//        [_imageView.layer setCornerRadius:10.0];
        [_imageView.layer setMasksToBounds:YES];
    }
    return _imageView;
}

-(void)setMyPhotoArray:(NSArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    [_photoArray addObjectsFromArray:photoArray];
    for (id obj in _photoArray) {
        [selectArray addObject:@(NO)];
        [delArray addObject:@(NO)];
    }
    [selectArray replaceObjectAtIndex:0 withObject:@(YES)];
    self.currentPosition = 0;
//    self.currentImage = [self.photoArray objectAtIndex:0];
    self.imageView.image = [self.photoArray objectAtIndex:self.currentPosition];
}

-(UIView *)prePhotoView{
    if (!_prePhotoView) {
        _prePhotoView = [[UIView alloc] init];
        
//        [_editPhotosView setFrame:CGRectMake(5+30+5, 0, self.view.frame.size.width - 40 - 60-10, 64)];
        [_prePhotoView setBackgroundColor:[UIColor lightGrayColor]];
        UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 17, 30, 30)];
        UIFont *font = [UIFont fontWithName:@"iconfont" size:20];
        
        [backbtn setFont:font];
        [backbtn setTitle:@"\U0000e617" forState:UIControlStateNormal];
        
        [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(onclickback) forControlEvents:UIControlEventTouchUpInside];
        [_prePhotoView addSubview:backbtn];
        UIButton *nextbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, 17, 60, 30)];
        [nextbtn setFont:[UIFont systemFontOfSize:16]];
        [nextbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextbtn addTarget:self action:@selector(onclicknext) forControlEvents:UIControlEventTouchUpInside];
        [_prePhotoView addSubview:nextbtn];
        [_prePhotoView addSubview:self.editPhotosView];
    }
    return _prePhotoView;
}

-(void)onclicknext{
    
}

-(void) onclickback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.prePhotoView];
    
    [self.view addSubview:self.editView];
    [self.view addSubview:self.adjustView];
    [self.view addSubview:self.editSelectItem];
    
}

-(void)viewDidLayoutSubviews{
    
//    CGRect frameEditSelectFrame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width,50);
//    
//    [self.editSelectItem setFrame:frameEditSelectFrame];
    
    CGRect framePreView = CGRectMake(0, 0, self.view.bounds.size.width, TOP_HEIGHT);
    
    [self.prePhotoView setFrame:framePreView];
    
    CGRect frameEditView = CGRectMake(20, 20 + TOP_HEIGHT, self.view.bounds.size.width - 40,self.view.bounds.size.height - self.editSelectItem.frame.size.height - 40 - TOP_HEIGHT);
    [self.editView setFrame:frameEditView];
    
    [self.imageSticker setFrame:self.editView.bounds];
    [self.imageView setFrame:self.editView.bounds];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)setNewImage:(UIImage *) image{
    [self.photoArray replaceObjectAtIndex:self.currentPosition withObject:image];
    //            self.currentImage = image;
    self.imageView.image = [self.photoArray objectAtIndex:self.currentPosition];
    [self.editPhotosView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void) selectButton:(NSInteger) tag{
    switch (tag) {
        case 0:
        {
            
            [self onMark];
        }
            break;
        case 1:
        {
            [self onFrame];
            
        }
            break;
        case 2:
        {
            
             [self onSticker];
        }
            break;
       
        case 3:
        {
           
            self.isEffect = !self.isEffect;
            if (self.isEffect) {
                [self onEffect];
            }else{
                [self downEffect];
            }
        }
            break;
        default:
            break;
    }
}

#pragma action

-(void)onRotate{
    RotateViewController *rvc = [[RotateViewController alloc] initWithImage:[self.photoArray objectAtIndex:self.currentPosition]];
    [rvc setFinish:^(UIImage *image) {
        [self setNewImage:image];
    } Cancel:^{
        
    }];
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)onClip{
    UIImage * oimage =[self.photoArray objectAtIndex:self.currentPosition];
    CropViewController *cropvc = [[CropViewController alloc ]initWithImage:oimage];
    
    [cropvc setFinish:^(UIImage *image) {
        [self setNewImage:image];
        [cropvc dismissViewControllerAnimated:YES completion:nil];
    } Cancel:^{
        [cropvc dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:cropvc animated:YES completion:nil];
//    return;
//    ClipViewController* clipvc = [[ClipViewController alloc] initWithImage:[self.photoArray objectAtIndex:self.currentPosition]];
//    [clipvc setFinish:^(UIImage *image) {
//        [self setNewImage:image];
//        [clipvc dismissViewControllerAnimated:YES completion:nil];
//    } Cancel:^{
//        [clipvc dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [self presentViewController:clipvc animated:YES completion:nil];
}

-(void)onFrame{
    
    ZZBorderPickViewController *bvc = [[ZZBorderPickViewController alloc] initWithImage:[self.photoArray objectAtIndex:self.currentPosition]];
    [bvc setFinish:^(UIImage *image) {
         [self setNewImage:image];
        [bvc dismissViewControllerAnimated:YES completion:nil];
    } Cancel:^{
        [bvc dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:bvc animated:YES completion:nil];
//    return;
    
    
}

-(void)onMark{
    
    FilterViewController* filtervc = [[FilterViewController alloc] init];
    filtervc.originalImage = [self.photoArray objectAtIndex:self.currentPosition];
    [filtervc setFinish:^(UIImage *image) {
        [self setNewImage:image];
        [filtervc dismissViewControllerAnimated:YES completion:nil];
    } Cancel:^{
        [filtervc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [self presentViewController:filtervc animated:YES completion:nil];

}
- (void)onEffect{
    

    CGRect frameStickerScrollView = CGRectMake(0, self.view.bounds.size.height - self.editSelectItem.bounds.size.height - ADJUSTMENT_HEIGHT,self.view.bounds.size.width, ADJUSTMENT_HEIGHT);
    
    [UIView animateWithDuration:.3 animations:^{
        [self.adjustView setFrame:frameStickerScrollView];
    }];
    
}

-(void)downEffect{
    CGRect frameStickerScrollView = CGRectMake(0, self.view.bounds.size.height - self.editSelectItem.bounds.size.height,self.view.bounds.size.width, ADJUSTMENT_HEIGHT);
    
    [UIView animateWithDuration:.3 animations:^{
        [self.adjustView setFrame:frameStickerScrollView];
    }];

}

- (void)onSticker{
    StickerViewController* stickervc = [[StickerViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:stickervc];
    [stickervc setSelectBlock:^(Sticker *sticker) {
        StickerEditViewController* stickerevc = [[StickerEditViewController alloc] initWithImage:[self.photoArray objectAtIndex:self.currentPosition] sticker:sticker];
        
        [stickerevc setFinish:^(UIImage *image) {
            [nav dismissViewControllerAnimated:YES completion:nil];
             [self setNewImage:image];
        } Cancel:^{
            [nav dismissViewControllerAnimated:YES completion:nil];
        }];
        [nav pushViewController:stickerevc animated:YES];
    }];
    
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - delegate
static NSString * CellIdentifier = @"GradientCell";
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == self.photoArray.count) {
        XPhotoPicker *xpp = [[XPhotoPicker alloc] initWithViewController:self onOK:^(NSArray *assets) {
            
            [self.photoArray addObjectsFromArray:assets];
            for (int i = 0; i<assets.count; i++) {
                [delArray addObject:@(NO)];
                [selectArray addObject:@(NO)];
            }
            [self.editPhotosView reloadData];
        } onCancel:^{
            
        }];
        xpp.maxCount = MAX_COUNT - self.photoArray.count;
        [xpp show];
        return;
    }
    
    for (int i = 0; i<delArray.count; i++) {
        [delArray replaceObjectAtIndex:i withObject:@(NO)];
    }
    for (int i = 0; i<selectArray.count; i++) {
        [selectArray replaceObjectAtIndex:i withObject:@(NO)];
    }
    [selectArray replaceObjectAtIndex:indexPath.row withObject:@(YES)];
    [self.editPhotosView reloadData];
    
//    self.currentImage = [self.photoArray objectAtIndex:indexPath.row];
    self.currentPosition = indexPath.row;
    self.imageView.image = [self.photoArray objectAtIndex:self.currentPosition];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelected:NO];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.photoArray.count<9) {
        return self.photoArray.count +1;
    }
    return self.photoArray.count;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    cell.img.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    
    
    cell.position = indexPath.row;
    if (self.photoArray.count<9&&indexPath.row==self.photoArray.count){
        cell.i_del.hidden = YES;
        cell.imgBg.hidden = YES;
        [cell setLongPressDisable];
        [cell.img setImage:[UIImage imageNamed:@"add"]];
//        [cell.img setImage:nil];
        return cell;
    }else{
        [cell setLongPressEnable];
        [cell.img setBackgroundColor:[UIColor clearColor]];
    }
    [cell.img setImage:[self.photoArray objectAtIndex:indexPath.row]];
    BOOL delVisi = [[delArray objectAtIndex:indexPath.row] boolValue];
    BOOL selectPosi = [[selectArray objectAtIndex:indexPath.row] boolValue];
    if (delVisi) {
        cell.i_del.hidden = NO;
    }else{
        cell.i_del.hidden = YES;
    }
    if (selectPosi) {
        cell.imgBg.hidden = NO;
    }else{
        cell.imgBg.hidden = YES;
    }
    [cell setOnClickDel:^(int position){
        
        [selectArray removeObjectAtIndex:position];
        [delArray removeObjectAtIndex:position];
        [_photoArray removeObjectAtIndex:position];
        [self.editPhotosView reloadData];
    }];
    [cell setOnLongPress:^(int position){
        
        
        for (int i = 0; i<delArray.count; i++) {
            [delArray replaceObjectAtIndex:i withObject:@(NO)];
        }
        [delArray replaceObjectAtIndex:indexPath.row withObject:@(YES)];
        [self.editPhotosView reloadData];
    }];
    if (self.photoArray.count==1) {
        [cell setLongPressDisable];
    }
    
    
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(64, 64);
}

//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
