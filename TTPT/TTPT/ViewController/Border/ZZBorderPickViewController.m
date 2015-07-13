//
//  ZZBorderPickViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ZZBorderPickViewController.h"
#import "UIView+Frame.h"
@implementation ZZBorderPickViewController{
    UIImageView *frameView;
}

-(instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _originalImage = image;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.targetImageView setImage:_originalImage];
    frameView  = [[UIImageView alloc] initWithFrame:self.targetImageView.frame];
//    [self.view addSubview:frameView];
    [self.view insertSubview:frameView belowSubview:self.bottomView];
    
    [self setTitle:@"边框"];
    
    [self initFuntionView];
}
-(void)onClickFinish:(id)sender{
    
    if (fblock) {
        fblock([self buildImage:_originalImage]);
    }
}
-(void)initFuntionView{
    float w = self.view.width;
    float h= self.view.height;
    
    _borderToolsView = [[BorderToolsView alloc ]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50 - STICKERITEM_HEIGHT, self.view.bounds.size.width,STICKERITEM_HEIGHT)];
    [_borderToolsView setSelectBlock:^(UIImage *image){
        [frameView setImage:image];
    }];
    [self.view addSubview:_borderToolsView];
}
- (UIImage*)buildImage:(UIImage*)image
{
    UIImage *frameImage = frameView.image;
    UIImage *result = [UIImage imageNamed:@""];
    if (!frameImage) {
        return _originalImage;
    }
    
    return result;
}
@end
