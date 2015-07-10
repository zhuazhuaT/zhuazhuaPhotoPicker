//
//  AdjustmentViewController.m
//  TTPT
//
//  Created by bu88 on 15/7/9.
//  Copyright (c) 2015年 Quan. All rights reserved.
//

#import "AdjustmentViewController.h"
#import "UIImage+Utility.h"
#define slide_height  35
@implementation AdjustmentViewController{
    UISlider *_actionSlider;
    FilterMode mode;
    
//    UIImage *_thumbnailImage;
}

-(instancetype)initWithImage:(UIImage *)image withType:(FilterMode)type{
    self = [super init];
    if (self) {
        mode = type;
        _originalImage = image;
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    _actionSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottom_height - slide_height, self.view.bounds.size.width, slide_height)];
    [self.targetImageView setImage:_originalImage];
//    _thumbnailImage = [_originalImage resize:self.targetImageView.frame.size];
    
    
    switch (mode) {
        case Filter_brightness:
        {
            _actionSlider = [self sliderWithValue:0 minimumValue:-1 maximumValue:1 action:@selector(sliderDidChange:)];
        }
            break;
        case Filter_Contrast:
        {
            _actionSlider = [self sliderWithValue:1 minimumValue:0.5 maximumValue:1.5 action:@selector(sliderDidChange:)];
        }
            break;
        case Filter_Saturation:
        {
            _actionSlider = [self sliderWithValue:1 minimumValue:0 maximumValue:2 action:@selector(sliderDidChange:)];
        }
            break;
        default:
            break;
    }
    
}

- (void)sliderDidChange:(UISlider*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage withMode:mode];
        [self.targetImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image withMode:(FilterMode )curmode
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    switch (curmode) {
        case Filter_Saturation:
        {
            filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
            
            [filter setDefaults];
            [filter setValue:[NSNumber numberWithFloat:_actionSlider.value] forKey:@"inputSaturation"];
            
            filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
            [filter setDefaults];
            CGFloat brightness = 0;
            [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
            
            filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
            [filter setDefaults];
            CGFloat contrast   = 1;
            [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
            
        }
            break;
        case Filter_Contrast:
        {
            filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
            
            [filter setDefaults];
            [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputSaturation"];
            
            filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
            [filter setDefaults];
            CGFloat brightness = 0;
            [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
            
            filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
            [filter setDefaults];
            CGFloat contrast   = _actionSlider.value*_actionSlider.value;
            [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
        }
            break;
        case Filter_brightness:
        {
            filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
            
            [filter setDefaults];
            [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputSaturation"];
            
            filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
            [filter setDefaults];
            CGFloat brightness = 2*_actionSlider.value;
            [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
            
            filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
            [filter setDefaults];
            CGFloat contrast   = 1;
            [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
        }
            break;
        default:
            break;
    }
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, slide_height)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - bottom_height - slide_height, self.view.bounds.size.width, slide_height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slide_height/2;
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.view addSubview:container];
    
    return slider;
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
        fblock(self.targetImageView.image);
    }
}

@end
