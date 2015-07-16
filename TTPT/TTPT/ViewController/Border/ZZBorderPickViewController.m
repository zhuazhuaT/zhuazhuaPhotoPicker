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
    float w = self.view.width;
    float h= self.view.height;
    float r = _originalImage.size.width/_originalImage.size.height;
    
    frameView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, w/r)];
    frameView.center = self.view.center;
//    [self.view addSubview:frameView];
    [self.view sendSubviewToBack:frameView];
    [self.view insertSubview:frameView belowSubview:self.bottomView];
    
    [self setTitle:@"边框"];
//    self.navigationController.navigationBarHidden = YES;
    [self initFuntionView];
}
-(void)onClickFinish:(id)sender{
    
    if (fblock) {
        
        [self generateWithBlock:^(UIImage *image, NSError *error) {
            if (error==nil) {
                fblock(image);
            }
            
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)initFuntionView{
    
    _borderToolsView = [[BorderToolsView alloc ]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50 - STICKERITEM_HEIGHT, self.view.bounds.size.width,STICKERITEM_HEIGHT)];
    [_borderToolsView setSelectBlock:^(UIImage *image){
        // 左端盖宽度
        CGFloat top = image.size.height/2-1; // 顶端盖高度
        CGFloat bottom = image.size.height/2-1; // 底端盖高度
        CGFloat left = image.size.width/2-1; // 左端盖宽度
        CGFloat right = image.size.width/2-1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [frameView setImage:image];
    }];
    [self.view addSubview:_borderToolsView];
}


- (void)generateWithBlock:(void (^)(UIImage *, NSError *))block{
    
    UIGraphicsBeginImageContextWithOptions(frameView.frame.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_originalImage drawInRect:frameView.bounds];
    CGContextSaveGState(context);
    [frameView.image drawInRect:frameView.bounds];
//    UIView *view = frameView;
    // Center the context around the view's anchor point
//    CGContextTranslateCTM(context, [view center].x, view.center.y);
    // Apply the view's transform about the anchor point
//    CGContextConcatCTM(context, [view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
//    CGContextTranslateCTM(context,
//                          -[view bounds].size.width * [[view layer] anchorPoint].x,
//                          -[view bounds].size.height * [[view layer] anchorPoint].y);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    CGContextRestoreGState(context);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    block(ret, nil);
}

@end
