//
//  BaseWorkViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BaseWorkViewController.h"



@interface BaseWorkViewController(){
   UIImage *_destImage;
}
@property (nonatomic,strong) UIImageView* imageview;

@property (nonatomic, strong) UILabel* titlelabel;

@end

@implementation BaseWorkViewController
-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _originalImage = image;
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - bottom_height, self.view.bounds.size.width, bottom_height)];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    self.targetImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.targetImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.targetImageView];
    [self.view bringSubviewToFront:self.bottomView];
    [self.view addSubview:self.bottomView];
    UIFont *iconfont = [UIFont fontWithName:@"iconfont" size:20];
    UIButton* btn_cancel  = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - width_bt, 0, width_bt, width_bt)];
    [btn_cancel setFont:iconfont];
    [btn_cancel setTitle:@"\U0000e64a" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn_cancel];
    
    UIButton* btn_finish  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width_bt, width_bt)];
    [btn_finish setFont:iconfont];
    
    [btn_finish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_finish setTitle:@"\U0000e64d" forState:UIControlStateNormal];
    [btn_finish addTarget:self action:@selector(onClickFinish:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn_finish];
    
    float w = 160;
    float h = bottom_height;
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bottomView.frame.size.width - w)/2, 0, w, h)];
    [self.titlelabel setTextAlignment:NSTextAlignmentCenter];
    [self.bottomView addSubview:self.titlelabel];
    
}

- (void)setTitle:(NSString *)bottom_title{
    if (self.titlelabel) {
        self.titlelabel.text = bottom_title;
    }
}

-(void) onClickCancel:(id)sender{
    if (cblock) {
        cblock();
    }
}

-(void) onClickFinish:(id)sender{
    if (fblock) {
        fblock(_originalImage);
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)setFinish:(onFinishBlock)finishblock
           Cancel:(onCancelBlock)cancelblock{
    fblock = finishblock;
    cblock = cancelblock;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)setFinishBlock:(onFinishBlock)block{
    fblock = block;
}


@end
