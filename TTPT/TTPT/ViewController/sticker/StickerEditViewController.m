//
//  StickerEditViewController.m
//  TTPT
//
//  Created by guohao on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "StickerEditViewController.h"
#import "WorkView.h"
#import "StickerViewController.h"
@interface StickerEditViewController ()
@property (nonatomic,strong) WorkView* workview;
@end

@implementation StickerEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onpickStricker)];
    float w = 160;
    float h = bottom_height;
    UIButton *btn_pick = [[UIButton alloc] initWithFrame:CGRectMake((self.bottomView.frame.size.width - w)/2, 0, w, h)];
    [btn_pick addTarget:self action:@selector(onpickStricker) forControlEvents:UIControlEventTouchUpInside];
    [btn_pick setTitle:@"贴纸" forState:UIControlStateNormal];
    [self.bottomView addSubview:btn_pick];
}

-(void) onpickStricker{
    StickerViewController* stickervc = [[StickerViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:stickervc];
    [stickervc setSelectBlock:^(Sticker *sticker) {
        [nav dismissViewControllerAnimated:YES completion:nil];
        [self.workview addSticker:sticker];
        
    }];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (instancetype)initWithImage:(UIImage*)image
                      sticker:(Sticker*)sticker{
    self = [super init];
    
  
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    float r = image.size.width/image.size.height;
    
    self.workview = [[WorkView alloc] initWithFrame:CGRectMake(0, 0, w , w/r)];
    self.workview.center = self.view.center;
    [self.view addSubview:self.workview];
    [self.view sendSubviewToBack:self.workview];
    [self.workview setBaseImage:image];
    
    [self.workview addSticker:sticker];
    self.navigationController.navigationBarHidden = YES;
    
    //[self initBottomView];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


- (void)onClickFinish:(id)sender{
    if (fblock) {
        [self.workview generateWithBlock:^(UIImage *finalImage, NSError *error) {
            if (finalImage) {
                fblock(finalImage);
            }else{
                NSLog(@"error %@",error.description);
            }
        }];
    }
}
@end
