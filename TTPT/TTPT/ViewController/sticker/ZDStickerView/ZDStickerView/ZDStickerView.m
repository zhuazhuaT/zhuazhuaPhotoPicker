//
//  ZDStickerView.m
//
//  Created by Seonghyun Kim on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ZDStickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Frame.h"
#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
#define kZDStickerViewControlSize 36.0


@interface ZDStickerView ()

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *customControl;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGFloat preScale;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) NSInteger flipState1;
@property (nonatomic) CGPoint touchStart;

@end

@implementation ZDStickerView
@synthesize contentView, touchStart;

@synthesize prevPoint;
@synthesize preScale;
@synthesize deltaAngle, startTransform; //rotation
@synthesize resizingControl, deleteControl, customControl;
@synthesize preventsPositionOutsideSuperview;
@synthesize preventsResizing;
@synthesize preventsDeleting;
@synthesize preventsCustomButton;
@synthesize minWidth, minHeight;
@synthesize flipState1 = _flipState1;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (CATransform3D)rotateTransform:(CATransform3D)initialTransform clockwise:(BOOL)clockwise
{
    _flipState1 = (_flipState1==0) ? 1 : 0;
    CGFloat arg = 0*M_PI;
    if(!clockwise){
        arg *= -1;
    }
    
    CATransform3D transform = initialTransform;
    transform = CATransform3DRotate(transform, arg, 0, 0, 1);
    transform = CATransform3DRotate(transform, _flipState1*M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, 0*M_PI, 1, 0, 0);
    
    return transform;
}

- (void)rotateStateDidChange
{
    CATransform3D transform = [self rotateTransform:CATransform3DIdentity clockwise:YES];
    
    CGFloat arg = 0*M_PI;
    CGFloat Wnew = fabs(self.frame.size.width * cos(arg)) + fabs(self.frame.size.height * sin(arg));
    CGFloat Hnew = fabs(self.frame.size.width * sin(arg)) + fabs(self.frame.size.height * cos(arg));
    
    CGFloat Rw = self.frame.size.width / Wnew;
    CGFloat Rh = self.frame.size.height / Hnew;
    CGFloat scale = MIN(Rw, Rh) * 1;
    
    transform = CATransform3DScale(transform, scale, scale, 1);
    contentView.layer.transform = transform;
    
}
#ifdef ZDSTICKERVIEW_LONGPRESS
-(void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if([_delegate respondsToSelector:@selector(stickerViewDidLongPressed:)]) {
            [_delegate stickerViewDidLongPressed:self];
        }
    }
}
#endif

-(void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    if (NO == self.preventsDeleting) {
//        [self rotateStateDidChange];
        UIView * close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
    
    if([_delegate respondsToSelector:@selector(stickerViewDidClose:)]) {
        [_delegate stickerViewDidClose:self];
    }
}

-(void)customTap:(UIPanGestureRecognizer *)recognizer
{
    if (NO == self.preventsCustomButton) {
        [self rotateStateDidChange];
    }
    
    if([_delegate respondsToSelector:@selector(stickerViewDidCustomButtonTap:)]) {
        [_delegate stickerViewDidCustomButtonTap:self];
    }
}

-(void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state]== UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth+1,
                                     minHeight+1);
            resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                       self.bounds.size.height-kZDStickerViewControlSize,
                                              kZDStickerViewControlSize,
                                              kZDStickerViewControlSize);
            deleteControl.frame = CGRectMake(0, 0,
                                             kZDStickerViewControlSize, kZDStickerViewControlSize);
            customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                              0,
                                              kZDStickerViewControlSize,
                                              kZDStickerViewControlSize);
            prevPoint = [recognizer locationInView:self];
             
        } else {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - prevPoint.x);
            hChange = (point.y - prevPoint.y);
            
            if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
                prevPoint = [recognizer locationInView:self];
                return;
            }
            
            if (YES == self.preventsLayoutWhileResizing) {
                if (wChange < 0.0f && hChange < 0.0f) {
                    float change = MIN(wChange, hChange);
                    wChange = change;
                    hChange = change;
                }
                if (wChange < 0.0f) {
                    hChange = wChange;
                } else if (hChange < 0.0f) {
                    wChange = hChange;
                } else {
                    float change = MAX(wChange, hChange);
                    wChange = change;
                    hChange = change;
                }
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                              self.bounds.size.height-kZDStickerViewControlSize,
                                              kZDStickerViewControlSize, kZDStickerViewControlSize);
            deleteControl.frame = CGRectMake(0, 0,
                                             kZDStickerViewControlSize, kZDStickerViewControlSize);
            customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                            0,
                                            kZDStickerViewControlSize,
                                            kZDStickerViewControlSize);
            prevPoint = [recognizer locationInView:self];
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        float angleDiff = deltaAngle - ang;
        if (NO == preventsResizing) {
            self.transform = CGAffineTransformMakeRotation(-angleDiff);
        }
        
        borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
        [borderView setNeedsDisplay];
        
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    
    if ([recognizer state] == UIGestureRecognizerStateChanged){
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth+1,
                                     minHeight+1);
            resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                              self.bounds.size.height-kZDStickerViewControlSize,
                                              kZDStickerViewControlSize,
                                              kZDStickerViewControlSize);
            deleteControl.frame = CGRectMake(0, 0,
                                             kZDStickerViewControlSize, kZDStickerViewControlSize);
            customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                            0,
                                            kZDStickerViewControlSize,
                                            kZDStickerViewControlSize);
            preScale = recognizer.scale;
            
        } else {
            float scale = recognizer.scale;
            float wChange = 0.0, hChange = 0.0;
            
            wChange = self.width * (scale - preScale);
            hChange = self.height * (scale - preScale);
            
            if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
                
                preScale = recognizer.scale;
                return;
            }
            
            if (YES == self.preventsLayoutWhileResizing) {
                if (wChange < 0.0f && hChange < 0.0f) {
                    float change = MIN(wChange, hChange);
                    wChange = change;
                    hChange = change;
                }
                if (wChange < 0.0f) {
                    hChange = wChange;
                } else if (hChange < 0.0f) {
                    wChange = hChange;
                } else {
                    float change = MAX(wChange, hChange);
                    wChange = change;
                    hChange = change;
                }
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                              self.bounds.size.height-kZDStickerViewControlSize,
                                              kZDStickerViewControlSize, kZDStickerViewControlSize);
            deleteControl.frame = CGRectMake(0, 0,
                                             kZDStickerViewControlSize, kZDStickerViewControlSize);
            customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                            0,
                                            kZDStickerViewControlSize,
                                            kZDStickerViewControlSize);
            
        }
        
        borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
        [borderView setNeedsDisplay];
        
        [self setNeedsDisplay];
        
    }else if ([recognizer state] == UIGestureRecognizerStateEnded){
        
    }
    
}

- (void)setupDefaultAttributes {
    borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    [borderView setHidden:YES];
    [self addSubview:borderView];
    
    if (kSPUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5) {
        self.minWidth = kSPUserResizableViewDefaultMinWidth;
        self.minHeight = self.bounds.size.height * (kSPUserResizableViewDefaultMinWidth/self.bounds.size.width);
    } else {
        self.minWidth = self.bounds.size.width*0.5;
        self.minHeight = self.bounds.size.height*0.5;
    }
    self.preventsPositionOutsideSuperview = NO;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    self.preventsCustomButton = YES;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
#ifdef ZDSTICKERVIEW_LONGPRESS
    UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(longPress:)];
    [self addGestureRecognizer:longpress];
#endif                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 kZDStickerViewControlSize, kZDStickerViewControlSize)];
    deleteControl.backgroundColor = [UIColor clearColor];
    deleteControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/zd_btnrotate.png" ];
    deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(singleTap:)];
    [deleteControl addGestureRecognizer:singleTap];
    [self addSubview:deleteControl];
    
    resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                   self.frame.size.height-kZDStickerViewControlSize,
                                                                   kZDStickerViewControlSize, kZDStickerViewControlSize)];
    resizingControl.backgroundColor = [UIColor clearColor];
    resizingControl.userInteractionEnabled = YES;
    resizingControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/zd_btnscale.png" ];
    UIPanGestureRecognizer* panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(resizeTranslate:)];
    [resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:resizingControl];
    
    customControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                   0,
                                                                   kZDStickerViewControlSize, kZDStickerViewControlSize)];
    customControl.backgroundColor = [UIColor clearColor];
    customControl.userInteractionEnabled = YES;
    customControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/zd_btnrotate.png" ];
    UITapGestureRecognizer * customTapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(customTap:)];
    [customControl addGestureRecognizer:customTapGesture];
    [self addSubview:customControl];
    
    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    
    for (UIView* subview in [contentView subviews]) {
        [subview setFrame:CGRectMake(0, 0,
                                     contentView.frame.size.width,
                                     contentView.frame.size.height)];
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    [self bringSubviewToFront:borderView];
    [self bringSubviewToFront:resizingControl];
    [self bringSubviewToFront:deleteControl];
    [self bringSubviewToFront:customControl];
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    for (UIView* subview in [contentView subviews]) {
        [subview setFrame:CGRectMake(0, 0,
                                     contentView.frame.size.width,
                                     contentView.frame.size.height)];
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    borderView.frame = CGRectInset(self.bounds,
                                   kSPUserResizableViewGlobalInset,
                                   kSPUserResizableViewGlobalInset);
    resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                      self.bounds.size.height-kZDStickerViewControlSize,
                                      kZDStickerViewControlSize,
                                      kZDStickerViewControlSize);
    deleteControl.frame = CGRectMake(0, 0,
                                     kZDStickerViewControlSize, kZDStickerViewControlSize);
    customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                      0,
                                      kZDStickerViewControlSize,
                                      kZDStickerViewControlSize);
    [borderView setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    touchStart = [touch locationInView:self.superview];
    [self showEditingHandles];
    if([_delegate respondsToSelector:@selector(stickerViewDidBeginEditing:)]) {
        [_delegate stickerViewDidBeginEditing:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if([_delegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
        [_delegate stickerViewDidEndEditing:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if([_delegate respondsToSelector:@selector(stickerViewDidCancelEditing:)]) {
        [_delegate stickerViewDidCancelEditing:self];
    }
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y);
    if (self.preventsPositionOutsideSuperview) {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(resizingControl.frame, touchLocation)) {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    touchStart = touch;
}

- (void)hideDelHandle
{
    deleteControl.hidden = YES;
}

- (void)showDelHandle
{
    deleteControl.hidden = NO;
}

- (void)hideEditingHandles
{
    resizingControl.hidden = YES;
    deleteControl.hidden = YES;
    customControl.hidden = YES;
    [borderView setHidden:YES];
}

- (void)showEditingHandles
{
    if (NO == preventsCustomButton) {
        customControl.hidden = NO;
    } else {
        customControl.hidden = YES;
    }
    if (NO == preventsDeleting) {
        deleteControl.hidden = NO;
    } else {
        deleteControl.hidden = YES;
    }
    if (NO == preventsResizing) {
        resizingControl.hidden = NO;
    } else {
        resizingControl.hidden = YES;
    }
    [borderView setHidden:NO];
}

- (void)showCustmomHandle
{
    customControl.hidden = NO;
}

- (void)hideCustomHandle
{
    customControl.hidden = YES;
}

- (void)setButton:(ZDSTICKERVIEW_BUTTONS)type image:(UIImage*)image
{
    switch (type) {
        case ZDSTICKERVIEW_BUTTON_RESIZE:
            resizingControl.image = image;
            break;
        case ZDSTICKERVIEW_BUTTON_DEL:
            deleteControl.image = image;
            break;
        case ZDSTICKERVIEW_BUTTON_CUSTOM:
            customControl.image = image;
            break;
            
        default:
            break;
    }
}

@end
