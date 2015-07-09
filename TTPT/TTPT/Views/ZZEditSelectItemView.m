//
//  ZZEditSelectItemView.m
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "ZZEditSelectItemView.h"
@interface ZZEditSelectItemView()
@property(nonatomic,strong)UIImageView * backGroundImageView;
@end

@implementation ZZEditSelectItemView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backGroundImageView];
        self.itemtitles = @[@"edit_frame",@"edit_lomo",@"edit_paint",@"edit_paint"];
    }
    return self;
}

-(UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pe_bg_three.png"]];
    }
    return _backGroundImageView;
}

- (void)setOnClickButtonBlock:(OnClickButton)block{
    onClickButtonBlock = block;
}

-(NSArray *)items{
    if (!_items){
        NSMutableArray* marray = [NSMutableArray new];
        NSInteger n = self.itemtitles.count;
        
        for (int i = 0; i < n; i++) {
            UIButton* button = [[UIButton alloc]init];
            [button setBackgroundColor:[UIColor clearColor]];
            
            NSString* bt_title = self.itemtitles[i];
            NSString* bt_title_h = [NSString stringWithFormat:@"%@_h",bt_title];
            [button setBackgroundImage:[UIImage imageNamed:bt_title] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:bt_title_h] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(onclickBlock:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:i];
            [self addSubview:button];
            [marray addObject:button];
        }
         _items = [NSArray arrayWithArray:marray];
    }
    return _items;
}

-(void)onclickBlock:(id)sender{
    UIButton *btn = sender;
    if (onClickButtonBlock) {
        onClickButtonBlock(btn.tag);
    }
}


-(void)layoutSubviews{
    long n = self.itemtitles.count;
    float btWidth = self.bounds.size.width / n;
    for (int i = 0; i < n; i++) {
        UIButton* bt = self.items[i];
        CGRect frameButton = CGRectMake(btWidth * (i), 0, self.bounds.size.width / n,self.bounds.size.height);
        [bt setFrame:frameButton];
    }
    [self.backGroundImageView setFrame:self.bounds];
   
}

@end
