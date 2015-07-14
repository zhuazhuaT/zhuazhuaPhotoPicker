//
//  StickerViewController.m
//  payment
//
//  Created by guohao on 15/7/8.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "StickerViewController.h"
#import "Sticker.h"
#import "StickerCollectionViewCell.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define TitleHeight 64
#define CategoryHeight 40
#define LeftMenuWidth 100
#define space 5

#define LeftCellID @"leftCellID"
#define StickerID  @"StickerID"

@interface StickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    NSInteger currentSection;
    BOOL scrollLock;
}
@property (nonatomic,strong) NSArray* categoryarray;
@property (nonatomic,strong) NSArray* titlearray;
@property (nonatomic,strong) NSMutableArray* stickerarray;
@property (nonatomic,strong) UITableView* leftTableview;
@property (nonatomic,strong) UICollectionView* collectview;
@end

@implementation StickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    currentSection = 0;
    scrollLock = NO;
    [self prepareData];
    
    [self initTitleView];
    [self initCategroyView];
    [self initLeftMenu];
    [self initStickers];
    
    
}

- (void)prepareData{
    self.categoryarray = @[@"分类0",@"分类1",@"分类2",@"分类3",@"分类4",@"分类5",@"分类5",@"分类5",@"分类5",@"分类5"];
    self.titlearray = @[@"全部"];
    self.stickerarray = [NSMutableArray new];
    for (int i = 0; i < 24; i++) {
        Sticker* sticker = [[Sticker alloc] init];
        NSString* imgtitle = [NSString stringWithFormat:@"emoji%d.png",i];
        sticker.image = [UIImage imageNamed:imgtitle];
        sticker.stickerID = i;
        [self.stickerarray addObject:sticker];
    }
}

- (void)initTitleView{
    
    self.navigationItem.title = @"贴纸";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"X"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(onClose)];
    
   self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)onClose{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategroyView{
    float category_width = 50;
    NSInteger n = self.categoryarray.count;
    UIScrollView* scrollv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, CategoryHeight)];
    scrollv.contentSize = CGSizeMake(n * category_width, -64);
    scrollv.backgroundColor = [UIColor lightGrayColor];
    for (int i = 0; i < n; i++) {
        
        NSString* title = self.categoryarray[i];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * category_width, -64, category_width, CategoryHeight-1)];
        label.text = title;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        [scrollv addSubview:label];
    }
    
    
    [self.view addSubview:scrollv];
}

- (void)initLeftMenu{
    self.leftTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, TitleHeight+CategoryHeight, LeftMenuWidth, ScreenH - TitleHeight-CategoryHeight)];
    [self.leftTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:LeftCellID];
    self.leftTableview.backgroundColor = [UIColor clearColor];
    self.leftTableview.delegate = self;
    self.leftTableview.dataSource = self;
    self.leftTableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.leftTableview];
}

- (void)initStickers{
    self.collectview = [[UICollectionView alloc] initWithFrame:CGRectMake(LeftMenuWidth, TitleHeight+CategoryHeight,ScreenW - LeftMenuWidth , ScreenH - TitleHeight-CategoryHeight) collectionViewLayout:[self collectionViewFlowLayout]];
    self.collectview.backgroundColor = [UIColor clearColor];
    self.collectview.delegate = self;
    self.collectview.dataSource = self;
    
    [self.collectview registerClass:[StickerCollectionViewCell class] forCellWithReuseIdentifier:StickerID];
    [self.view addSubview:self.collectview];
}

- (void)viewWillAppear:(BOOL)animated{
    [self cleanTable];
}

- (void)cleanTable{
    if (self.titlearray.count) {
        [self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!scrollLock) {
        UICollectionViewCell* topcell = [self.collectview visibleCells][0];
        NSInteger section = [self.collectview indexPathForCell:topcell].section;
        
        for (UICollectionViewCell *cell in [self.collectview visibleCells]) {
            NSIndexPath *indexPath = [self.collectview indexPathForCell:cell];
            if (indexPath.section <= section) {
                section = indexPath.section;
            }
        }
        
        if (section != currentSection) {
            currentSection = section;
            [self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
    
    
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    scrollLock = NO;
}



#pragma mark - collection delegate

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    UICollectionViewFlowLayout* portraitLayout = [[UICollectionViewFlowLayout alloc] init];
    
    portraitLayout.minimumInteritemSpacing = space;
    int cellTotalUsableWidth = [UIScreen mainScreen].bounds.size.width - 5*space;
    portraitLayout.itemSize = CGSizeMake(100, 100);
    portraitLayout.minimumLineSpacing = space;
    portraitLayout.headerReferenceSize = CGSizeMake(ScreenW, 10.f);
    return portraitLayout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titlearray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stickerarray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StickerCollectionViewCell* cell = [self.collectview dequeueReusableCellWithReuseIdentifier:StickerID forIndexPath:indexPath];
    
    Sticker* ticker = self.stickerarray[indexPath.item];
    
    cell.imageview.image = ticker.image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int section = indexPath.section;
    int row = indexPath.row;
    Sticker* ticker = self.stickerarray[row];
    
    if (selectblock) {
        selectblock(ticker);
    }
}




#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlearray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.leftTableview dequeueReusableCellWithIdentifier:LeftCellID];
    
    NSString* title = self.titlearray[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.row;
    scrollLock = YES;
    [self.collectview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - callback
- (void)setSelectBlock:(onSelectStickerBlock)block{
    selectblock = block;
}



@end
