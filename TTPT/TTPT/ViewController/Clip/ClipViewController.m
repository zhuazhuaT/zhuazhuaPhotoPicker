//
//  ClipViewController.m
//  TTPT
//
//  Created by guohao on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ClipViewController.h"
#import "PhotoClipView.h"
@interface ClipViewController ()
@property (nonatomic,strong) PhotoClipView* clipview;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) NSArray* titles;
@end

@implementation ClipViewController

- (void)viewDidLoad {
    
    self.titles = @[@"原始",@"1:1",@"4:3",@"16:9"];
    
    
    self.clipview = [[PhotoClipView alloc] initWithRateFrame:self.view.bounds];
    self.clipview.backgroundColor = [UIColor blueColor];
    [self.clipview setImage:self.image];
    [self.view addSubview:self.clipview];
    [super viewDidLoad];
    
    [self initChooseView];
    
}

- (void)initChooseView{
    float y = self.view.bounds.size.height;
    float w = self.view.bounds.size.width;
    float h_tool = 50;
    UIView* toolview = [[UIView alloc] initWithFrame:CGRectMake(0, y - bottom_height-h_tool, w, h_tool)];
    toolview.backgroundColor = [UIColor lightGrayColor];
    NSInteger n = self.titles.count;
    float bt_w = w/n;
    for (int i = 0; i < n; i++) {
        UIButton*bt = [[UIButton alloc] initWithFrame:CGRectMake(i*bt_w, 0, bt_w, h_tool)];
        [bt setTitle:self.titles[i] forState:UIControlStateNormal];
        bt.tag = i;
        [bt addTarget:self action:@selector(onRate:) forControlEvents:UIControlEventTouchUpInside];
        [toolview addSubview:bt];
    }
    
    [self.view addSubview:toolview];
}

- (void)onRate:(id)sender{
    UIButton* bt = (UIButton*)sender;
    float rate = 0;
    switch (bt.tag) {
        case 0:
            
            break;
        case 1:
            rate = 1;
            break;
        case 2:
            rate = 4/3.0;
            break;
        case 3:
            rate = 16/9.0;
            break;
        default:
            break;
    }
    [self.clipview setClipFrameRate:rate];
}

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    self.image = image;
    return self;
}

- (void)onClickFinish:(id)sender{
    if (fblock) {
        UIImage* image = [self.clipview getCropImage];
        fblock(image);
    }
}


@end
