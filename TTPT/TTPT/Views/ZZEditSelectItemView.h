//
//  ZZEditSelectItemView.h
//  TTPT
//
//  Created by bu88 on 15/7/7.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OnClickButton)(NSInteger position);
@interface ZZEditSelectItemView : UIView{
    OnClickButton onClickButtonBlock;
}
//@property(nonatomic,strong)UIButton * button1;
//@property(nonatomic,strong)UIButton * button2;
//@property(nonatomic,strong)UIButton * button3;
//@property(nonatomic,strong)UIButton * button4;
@property(nonatomic,strong)NSArray * items;
@property(nonatomic,strong)NSArray * itemtitles;
@property(nonatomic,strong)NSArray * itemIconStrings;

-(void)setOnClickButtonBlock:(OnClickButton)block;

@end
