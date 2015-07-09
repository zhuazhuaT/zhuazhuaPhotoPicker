//
//  BaseWorkViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BaseWorkViewController.h"

#define width_bt 50
#define bottom_height 50

@interface BaseWorkViewController(){
    UIImage *_originalImage;
    UIImage *_destImage;
}

@property (nonatomic, strong) UIImageView *targetImageView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic, strong) UILabel* titlelabel;

@end

@implementation BaseWorkViewController

-(instancetype)initWithImage:(UIImage *)image onOK:(onFinishBlock)finishblock onCancel:(onCancelBlock)cancelblock{
    self = [super init];
    if (self) {
        _originalImage = image;
        cblock = cancelblock;
        fblock = finishblock;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - bottom_height, self.view.bounds.size.width, bottom_height)];
    [self.view addSubview:self.bottomView];
    
    UIButton* btn_cancel  = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - width_bt, 0, width_bt, width_bt)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn_cancel];
    
    UIButton* btn_finish  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width_bt, width_bt)];
    [btn_finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_finish addTarget:self action:@selector(onClickFinish:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn_finish];
    
    float w = 60;
    float h = 30;
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bottomView.bounds.size.width - w)/2, 0, w, h)];
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



-(void)setTitle:(NSString *)title{
    [self.label setText:title];
}

@end
