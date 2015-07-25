//
//  ViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ViewController.h"
#import "EditPhotoViewController.h"
#import "XPhotoPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试编辑图片";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.layer setBorderColor:[UIColor blueColor].CGColor];
    [btn.layer setBorderWidth:2];
    [self.view addSubview:btn];
    
    
}

-(void)onclick{
    
    XPhotoPicker *xpp = [[XPhotoPicker alloc] initWithViewController:self
                                                                onOK:^(NSArray *assets) {
        EditPhotoViewController *zzpvc = [[EditPhotoViewController alloc] init];
        [zzpvc setMyPhotoArray:assets];
        [zzpvc setEditedPhotoBlock:^(NSArray *photoArray){
            
        }];
        [self.navigationController pushViewController:zzpvc animated:YES];
    } onCancel:^{
        
    }];
    xpp.maxCount = 9;
    [xpp show];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
