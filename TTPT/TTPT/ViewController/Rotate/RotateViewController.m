//
//  RotateViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/10.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "RotateViewController.h"
#import "UIView+Frame.h"
static NSString* const kCLRotateToolRotateIconName = @"rotateIconAssetsName";
static NSString* const kCLRotateToolFlipHorizontalIconName = @"flipHorizontalIconAssetsName";
static NSString* const kCLRotateToolFlipVerticalIconName = @"flipVerticalIconAssetsName";



@interface CLRotatePanel : UIView
@property(nonatomic, strong) UIColor *bgColor;
@property(nonatomic, strong) UIColor *gridColor;
@property(nonatomic, assign) CGRect gridRect;
- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;
@end


@implementation RotateViewController{
    UIView *funView;
    NSInteger _flipState1;
    NSInteger _flipState2;
    CGRect _initialRect;
    CLRotatePanel *_gridView;
    UIImageView *_rotateImageView;
    float rotatedegree;
}

-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _originalImage = image;
        _flipState1 = 0;
        _flipState2 = 0;
        rotatedegree =0;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    float w = self.view.width;
    float h = self.view.height;
    
    [self.targetImageView setImage:_originalImage];
    
    [self setTitle:@"旋转"];
    
    
    
    _initialRect = self.view.frame;
    _gridView = [[CLRotatePanel alloc] initWithSuperview:self.targetImageView.superview frame:self.targetImageView.frame];
    _gridView.backgroundColor = [UIColor clearColor];
//    _gridView.bgColor = [self.view.backgroundColor colorWithAlphaComponent:0.8];
//    _gridView.gridColor = [[UIColor clearColor] colorWithAlphaComponent:0.8];
    _gridView.clipsToBounds = NO;
    
    
    _rotateImageView = [[UIImageView alloc] initWithFrame:_initialRect];
    [_rotateImageView setContentMode:UIViewContentModeScaleAspectFit];
    _rotateImageView.image = _originalImage;
    [_gridView.superview insertSubview:_rotateImageView belowSubview:self.bottomView];
    
    self.targetImageView.hidden = YES;
    [self.view bringSubviewToFront:funView];
    [self initFuntionView:h];
}
-(void)initFuntionView :(int)h{
    float w = self.view.bounds.size.width;
    float height = w /5;
    float width = w/4;
    float left =(width - height)/2  ;
    funView = [[UIView alloc] initWithFrame:CGRectMake(0, h- bottom_height - height, self.view.bounds.size.width, height)];
    [funView setBackgroundColor:[UIColor lightGrayColor]];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(left, 0, height, height)];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(left+width, 0, height, height)];
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(left+width *2, 0, height, height)];
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(left+width *3, 0, height, height)];
    
    [btn1 setImage:[UIImage imageNamed:@"btn_flip1.png"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"btn_flip2.png"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"btn_rotate.png"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"icon_rotate.png"] forState:UIControlStateNormal];
    int inseth = 12;
    int insetw = 12;
    [btn1 setContentEdgeInsets:UIEdgeInsetsMake(insetw, inseth, insetw, inseth)];
    [btn2 setContentEdgeInsets:UIEdgeInsetsMake(insetw, inseth, insetw, inseth)];
    [btn3 setContentEdgeInsets:UIEdgeInsetsMake(insetw, inseth, insetw, inseth)];
    [btn4 setContentEdgeInsets:UIEdgeInsetsMake(insetw, inseth, insetw, inseth)];
    
    btn1.tag = 111;
    btn2.tag = 112;
    btn3.tag = 113;
    btn4.tag = 114;
    
    [btn1 addTarget:self action:@selector(onFunctionClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(onFunctionClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(onFunctionClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(onFunctionClick:) forControlEvents:UIControlEventTouchUpInside];
    [funView addSubview:btn1];
    [funView addSubview:btn2];
    [funView addSubview:btn3];
    [funView addSubview:btn4];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height, w, 1)];
    [line setBackgroundColor:[UIColor blackColor]];
    [funView addSubview:line];
    
    
    [self.view addSubview:funView];
    
}

#pragma mark - function

-(void) onFunctionClick:(UIButton *)sender{
    switch (sender.tag) {
        case 111:
        {
            _flipState1 = (_flipState1==0) ? 1 : 0;
        }
            break;
        case 112:
        {
            _flipState2 = (_flipState2==0) ? 1 : 0;
        }
            break;
        case 113:
        {
            CGFloat value = (int)floorf((rotatedegree + 1)*2) + 1;
            if(value>4){
                value -= 4;
            }
            rotatedegree = value / 2 - 1;
            
            _gridView.hidden = YES;
        }
            break;
            
        case 114:
        {
            CGFloat value = (int)floorf((rotatedegree - 1)*2) - 1;
            if(value<0){
                value += 4;
            }
            rotatedegree = value / 2 + 1;
            
            _gridView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self rotateStateDidChange];
                     }
                     completion:^(BOOL finished) {
                         _gridView.hidden = YES;
                     }
     ];
    
}
- (CATransform3D)rotateTransform:(CATransform3D)initialTransform clockwise:(BOOL)clockwise
{
    CGFloat arg = rotatedegree*M_PI;
    if(!clockwise){
        arg *= -1;
    }
    
    CATransform3D transform = initialTransform;
    transform = CATransform3DRotate(transform, arg, 0, 0, 1);
    transform = CATransform3DRotate(transform, _flipState1*M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, _flipState2*M_PI, 1, 0, 0);
    
    return transform;
}

- (void)rotateStateDidChange
{
    CATransform3D transform = [self rotateTransform:CATransform3DIdentity clockwise:YES];
    
    CGFloat arg = rotatedegree*M_PI;
    CGFloat Wnew = fabs(_initialRect.size.width * cos(arg)) + fabs(_initialRect.size.height * sin(arg));
    CGFloat Hnew = fabs(_initialRect.size.width * sin(arg)) + fabs(_initialRect.size.height * cos(arg));
    
    CGFloat Rw = _gridView.width / Wnew;
    CGFloat Rh = _gridView.height / Hnew;
    CGFloat scale = MIN(Rw, Rh) * 1;
    
    transform = CATransform3DScale(transform, scale, scale, 1);
    _rotateImageView.layer.transform = transform;
    
    _gridView.gridRect = _rotateImageView.frame;
}

- (UIImage*)buildImage:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    CGAffineTransform transform = CATransform3DGetAffineTransform([self rotateTransform:CATransform3DIdentity clockwise:NO]);
    [filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

-(void)onClickCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
    if (cblock) {
        cblock();
    }
}

-(void)onClickFinish:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
    if (fblock) {
        fblock([self buildImage:_originalImage]);
    }
}

@end

@implementation CLRotatePanel

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame
{
    self = [super initWithFrame:superview.bounds];
    if(self){
        self.gridRect = frame;
        [superview addSubview:self];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.gridRect;
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextStrokeRect(context, rct);
}

- (void)setGridRect:(CGRect)gridRect
{
    _gridRect = gridRect;
    [self setNeedsDisplay];
}
@end
