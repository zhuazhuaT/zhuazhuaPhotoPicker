//
//  BaseWorkViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "BaseWorkViewController.h"

@interface BaseWorkViewController(){
    UIImage *_originalImage;
    UIImage *_destImage;
}

@property (nonatomic, strong) UIImageView *targetImageView;
@property(strong, nonatomic) UIView *bottomView;
//@property(strong, nonatomic) UIImageView *bottomBg;
@property (strong, nonatomic) UIButton *btn_finish;
@property(strong,nonatomic) UIButton *btn_cancel;
@property(strong, nonatomic) UILabel *label;
@end

@implementation BaseWorkViewController

-(instancetype)initWithImage:(UIImage *)image onOK:(onFinishBlock)finishblock onCancel:(onCancelBlock)cancelblock{
    self = [super init];
    if (self) {
        _originalImage = image;
        cblock = cancelblock;
        fblock = finishblock;
    }
    return self;
}
-(UIView *)bottomView{
    if(!_bottomView)
    {
        _bottomView = [[UIView alloc ] init];
        [_bottomView addSubview:self.btn_finish];
        [_bottomView addSubview:self.btn_cancel];
        
    }
    return _bottomView;
}
-(UILabel *)label{
    if (_label) {
        _label = [[UILabel alloc] init];
        
    }
    return _label;
}

-(UIButton *)btn_cancel{
    if (!_btn_cancel) {
        _btn_cancel  = [[UIButton alloc] init];
        [_btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btn_cancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn_cancel;
}

-(UIButton *)btn_finish{
    if (!_btn_finish) {
        _btn_finish = [[UIButton alloc] init];
        [_btn_finish addTarget:self action:@selector(onClickFinish:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn_finish;
}

-(void) onClickCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onClickFinish:(id)sender{
    
    
    if (fblock) {
        fblock(_originalImage);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.bottomView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.bottomView setFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    [self.label setFrame:self.bottomView.frame];
    [self.btn_finish setFrame:CGRectMake(0, 0, 50, 50)];
    [self.btn_cancel setFrame:CGRectMake(self.view.bounds.size.width - 50, 0, 50, 50)];
    
    
    
}



@end
