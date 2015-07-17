//
//  ZZEditSelectItemView.m
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "EditSelectItemView.h"
#import "ButtonView.h"
@interface EditSelectItemView()
@property(nonatomic,strong)UIImageView * backGroundImageView;
@end

@implementation EditSelectItemView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.backGroundImageView];
        self.backgroundColor = [UIColor grayColor];
        self.itemtitles =@[@"滤镜",@"边框",@"贴纸",@"编辑"];
        self.itemIconStrings = @[@"\U0000e64b",@"\U0000e655",@"\U0000e656",@"\U0000e64c"];
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
            ButtonView* button = [[ButtonView alloc]init];
            [button setBackgroundColor:[UIColor clearColor]];
            
            NSString* bt_title = self.itemtitles[i];
            [button setTitle:bt_title];
            [button setIconString:self.itemIconStrings[i]];
            [button.btnframe addTarget:self action:@selector(onclickBlock:) forControlEvents:UIControlEventTouchUpInside];
            [button.btnframe setTag:i];
            [self addSubview:button];
            [marray addObject:button];
        }
         _items = [NSArray arrayWithArray:marray];
    }
    return _items;
}

-(void)onclickBlock:(id)sender{
    UIView *btn = sender;
    if (onClickButtonBlock) {
        onClickButtonBlock(btn.tag);
    }
}


-(void)layoutSubviews{
    long n = self.itemtitles.count;
    float btWidth = self.bounds.size.width / n;
    for (int i = 0; i < n; i++) {
        ButtonView* bt = self.items[i];
        CGRect frameButton = CGRectMake(btWidth * (i), 0, self.bounds.size.width / n,self.bounds.size.height);
        [bt setFrame:frameButton];
    }
//    [self.backGroundImageView setFrame:self.bounds];
   
}

@end
