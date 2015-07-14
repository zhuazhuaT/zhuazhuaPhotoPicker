//
//  PhotoClipView.m
//  photoclip
//
//  Created by guohao on 15/5/2.
//  Copyright (c) 2015年 guohao. All rights reserved.
//

#import "PhotoClipView.h"

@interface PhotoClipView ()<UIScrollViewDelegate>{
    float minScale;
    float curRate;
}
@property (nonatomic,strong)UIImageView *imageview;
@property (nonatomic,strong)UIScrollView *contentscrollv;
@property (nonatomic,strong)UIView* clipFrameView;
@end


@implementation PhotoClipView

- (instancetype)initWithFrame:(CGRect)frame
                     withType:(ClipType)ctype{
    self = [super initWithFrame:frame];
    float width = frame.size.width;
    type = ctype;
    curRate = 1;    self.contentscrollv = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.contentscrollv.delegate = self;
    minScale = 1;
    self.contentscrollv.minimumZoomScale = minScale;
    self.contentscrollv.maximumZoomScale = 5;
    self.contentscrollv.backgroundColor = [UIColor blackColor];
    [self addSubview:self.contentscrollv];
    
    
    self.imageview = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentscrollv addSubview:self.imageview];
    
    
    UIImage* msk = nil;
    if (type == ct_Round) {
        msk = [UIImage imageNamed:@"roundclip"];
    }else{
        msk = [UIImage imageNamed:@"hexaclip"];
    }
    
    float rr = msk.size.width/msk.size.height;
    
    UIImageView* imv = [[UIImageView alloc] initWithImage:msk];
    imv.frame = CGRectMake(0, 0, width, width/rr);
    imv.center = self.center;
    [self addSubview:imv];
    
    
    
//    UIView* sview =[[UIView alloc] initWithFrame:[self getClipRect]];
////    sview.center = self.center;
//    sview.backgroundColor = [UIColor clearColor];
//    sview.layer.borderColor = [UIColor redColor].CGColor;
//    sview.layer.borderWidth = 2;
//    sview.userInteractionEnabled = NO;
//    [self addSubview:sview];
    
    
    
    return  self;
}

- (instancetype)initWithRateFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    float width = frame.size.width;
    curRate = 1;
    self.contentscrollv = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.contentscrollv.delegate = self;
    minScale = 1;
    self.contentscrollv.minimumZoomScale = minScale;
    self.contentscrollv.maximumZoomScale = 5;
    self.contentscrollv.backgroundColor = [UIColor blackColor];
    [self addSubview:self.contentscrollv];
    
    
    self.imageview = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentscrollv addSubview:self.imageview];
    
        self.clipFrameView =[[UIView alloc] initWithFrame:[self getClipRect]];
    //    sview.center = self.center;
        self.clipFrameView.backgroundColor = [UIColor clearColor];
        self.clipFrameView.layer.borderColor = [UIColor redColor].CGColor;
        self.clipFrameView.layer.borderWidth = 2;
        self.clipFrameView.userInteractionEnabled = NO;
        [self addSubview:self.clipFrameView];
    return self;
}

- (void)resetUIscrollview{
    self.contentscrollv.contentOffset = CGPointZero;
    self.contentscrollv.contentScaleFactor = 1;
    
    self.contentscrollv.minimumZoomScale = minScale;
    self.contentscrollv.maximumZoomScale = 5;
}

- (void)setImage:(UIImage *)image{
    
    
    [self resetUIscrollview];
    
    _image = [self fixOrientation:image];
    self.imageview.image = _image;
    float r = _image.size.width/_image.size.height;
    float w = self.frame.size.width;
    
    if (r > 1){
        self.imageview.frame = CGRectMake(0, 0, w*r,w );
    }else{
        self.imageview.frame = CGRectMake(0, 0, w, w/r);
    }
    [self resize];
    int x = abs(self.contentscrollv.contentSize.width - self.contentscrollv.frame.size.width)/2;
    int y = abs(self.contentscrollv.contentSize.height - self.contentscrollv.frame.size.height) /2;
    [self.contentscrollv setContentOffset:CGPointMake(x, y) animated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self resize];
}

- (void)resize{
    CGRect rect = self.imageview.frame;
    float ww = rect.size.width;
    float hh = rect.size.height;
    CGSize size = CGSizeZero;
    
    size.width = rect.size.width;
    float delta = [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width;

    size.height = rect.size.height + delta;
    [self.contentscrollv setContentSize:size];
    self.imageview.frame = CGRectMake(0, delta/2, ww, hh);
}

- (CGRect)getClipRect{
    float width = self.frame.size.width;
    float h = [UIScreen mainScreen].bounds.size.height;
    float middle_h = (h-width)/2;
    return CGRectMake(0, middle_h, width, width);
}

- (CGRect)getClipRectByRate:(float)rate{
    float width = self.frame.size.width;
    float height = width/rate;
    float h = [UIScreen mainScreen].bounds.size.height;
    float middle_h = (h-height)/2;
    return CGRectMake(0, middle_h, width, height);
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    NSLog(@"oritation %d",aImage.imageOrientation);
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage*)getCropImage{
    CGRect rct = [self getClipRectByRate:curRate];
    
    UIImage* originalImage = self.imageview.image;
    
    CGRect  bounds = self.imageview.frame; // Considering image is shown in 320*320
    CGRect rect = [self convertRect:rct toView:self.imageview];; //rectangle area to be cropped
    float s = self.contentscrollv.zoomScale;
    float scale = originalImage.size.width*s/bounds.size.width;
    
    float widthFactor = rect.size.width * scale;
    float heightFactor = rect.size.height * scale;
    float factorX = rect.origin.x * scale;
    float factorY = rect.origin.y * scale;
    CGRect factoredRect = CGRectMake(factorX,factorY,widthFactor,heightFactor);
    
    CGAffineTransform rotateTransform = CGAffineTransformIdentity;
    
    switch (originalImage.imageOrientation) {
        case UIImageOrientationDown:
            rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, -originalImage.size.width, -originalImage.size.height);
            break;
            
        case UIImageOrientationLeft:
            rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI_2);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, 0.0, -originalImage.size.height);
            break;
            
        case UIImageOrientationRight:
            rotateTransform = CGAffineTransformRotate(rotateTransform, -M_PI_2);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, -originalImage.size.width, 0.0);
            break;
            
        default:
            break;
    }
    
    CGRect rotatedCropRect = CGRectApplyAffineTransform(factoredRect, rotateTransform);
    
    
    UIImage *cropImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([originalImage CGImage], rotatedCropRect)];
    
    return  cropImage;
}

#pragma mark - change rate
- (void)setClipFrameRate:(float)rate{
    curRate = rate;
    if(rate){
        self.clipFrameView.hidden = NO;
        self.clipFrameView.frame = [self getClipRectByRate:rate];
    }else{
        self.clipFrameView.hidden = YES;
    }
   
    [self resetImagebyRate:rate];
}

- (void)resetImagebyRate:(float)rate{
    
    float r = _image.size.width/_image.size.height;
    float w = self.frame.size.width;

    
    if (rate == 1|| r < 1 || rate == 0) {
        
        if (r > 1){
            self.imageview.frame = CGRectMake(0, 0, w*r,w );
        }else{
            self.imageview.frame = CGRectMake(0, 0, w, w/r);
        }
        [self resizeWithRate:rate];
        int x = abs(self.contentscrollv.contentSize.width - self.contentscrollv.frame.size.width)/2;
        int y = abs(self.contentscrollv.contentSize.height - self.contentscrollv.frame.size.height) /2;
        [self.contentscrollv setContentOffset:CGPointMake(x, y) animated:YES];
    }else{
        
        if (r > rate){
            self.imageview.frame = CGRectMake(0, 0, w/rate*r,w/rate );
        }else{
            self.imageview.frame = CGRectMake(0, 0, w, w/r);
        }
        [self resizeWithRate:rate];
        int x = abs((int)self.contentscrollv.contentSize.width - (int)self.contentscrollv.frame.size.width)/2;
        int y = abs((int)self.contentscrollv.contentSize.height - (int)self.contentscrollv.frame.size.height) /2;
        [self.contentscrollv setContentOffset:CGPointMake(x, y) animated:YES];
    }
    
}

- (void)resizeWithRate:(float)rate{
    CGRect rect = self.imageview.frame;
    float ww = rect.size.width;
    float hh = rect.size.height;
    CGSize size = CGSizeZero;
    
    size.width = rect.size.width;
    float delta = [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width/rate;
    
    size.height = rect.size.height + delta;
    [self.contentscrollv setContentSize:size];
    self.imageview.frame = CGRectMake(0, delta/2, ww, hh);
}

@end
