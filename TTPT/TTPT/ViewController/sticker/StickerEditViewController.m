//
//  StickerEditViewController.m
//  TTPT
//
//  Created by guohao on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "StickerEditViewController.h"
#import "WorkView.h"
@interface StickerEditViewController ()
@property (nonatomic,strong) WorkView* workview;
@end

@implementation StickerEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithImage:(UIImage*)image
                      sticker:(Sticker*)sticker{
    self = [super init];
    
  
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    self.workview = [[WorkView alloc] initWithFrame:CGRectMake(0, 0, w , h)];
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
