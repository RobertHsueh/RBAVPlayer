//
//  RBProgressSlider.m
//  RBAVPlayer
//
//  Created by Robert on 2015/1/23.
//  Copyright (c) 2015年 virentech. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "RBProgressSlider.h"
#import <objc/message.h>

#define POINT_OFFSET    (2)

#pragma mark - UIImage (RBSlider)

@interface UIImage (RBSlider)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@implementation UIImage (RBSlider)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end


#pragma mark - RBProgressSlider

@interface RBProgressSlider ()
{
    RBSlider *slider;
    RBProgressView *progressView;
    BOOL isLoaded;
    __weak id eventTouchTarget;
    __weak id eventSlideTarget;
    SEL eventTouchAction;
    SEL eventSlideAction;
}
@end


@implementation RBProgressSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initObject];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initObject];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self initObject];
}

- (void)initObject
{
    // Initialization code
    [self loadSubView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadSubView
{
    if (isLoaded) {
        return;
    }
    isLoaded = YES;
    
    self.backgroundColor = [UIColor clearColor];
    slider = [[RBSlider alloc] initWithFrame:self.bounds];
    slider.trackHeight = 3;
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:slider];
    
    CGRect rect = slider.bounds;
    rect.origin.x += POINT_OFFSET;
    rect.size.width -= POINT_OFFSET * 2;
    progressView = [[RBProgressView alloc] initWithFrame:rect];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    progressView.center = slider.center;
    progressView.userInteractionEnabled = false;
    self.middleTackClipsToBounds = true;
    
    [slider addSubview:progressView];
    [slider sendSubviewToBack:progressView];
    
    progressView.progressTintColor = [UIColor darkGrayColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    slider.maximumTrackTintColor = [UIColor clearColor];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self loadSubView];
    
    if (controlEvents == UIControlEventTouchUpInside) {
        eventTouchTarget = target;
        eventTouchAction = action;
        [slider addTarget:self action:@selector(onSliderTouched) forControlEvents:controlEvents];
    }else if (controlEvents == UIControlEventValueChanged) {
        eventSlideTarget = target;
        eventSlideAction = action;
        [slider addTarget:self action:@selector(onSliderValueChanged) forControlEvents:controlEvents];
    }
}

- (void)onSliderValueChanged
{
//    objc_msgSend(eventSlideTarget, eventSlideAction, self);
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [eventSlideTarget performSelector:eventSlideAction withObject:self];
    #pragma clang diagnostic pop
}

- (void)onSliderTouched
{
//    objc_msgSend(eventTouchTarget, eventTouchAction, self);
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [eventTouchTarget performSelector:eventTouchAction withObject:self];
    #pragma clang diagnostic pop
}


#pragma mark - setter & getter

- (float)value
{
    return slider.value;
}

- (void)setValue:(float)value
{
    slider.value = value;
}

- (float)middleValue
{
    return progressView.progress;
}

- (void)setMiddleValue:(float)middleValue
{
    progressView.progress = middleValue;
}

- (float)minimumValue
{
    return slider.minimumValue;
}

- (void)setMinimumValue:(float)minimumValue
{
    slider.minimumValue = minimumValue;
}

- (float)maximumValue
{
    return slider.maximumValue;
}

- (void)setMaximumValue:(float)maximumValue
{
    slider.maximumValue = maximumValue;
}

- (BOOL)middleTackClipsToBounds
{
    return progressView.clipsToBounds;
}

- (void)setMiddleTackClipsToBounds:(BOOL)middleTackClipsToBounds
{
    progressView.clipsToBounds = middleTackClipsToBounds;
}

- (CGFloat)middleTackHeight
{
    return progressView.height;
}

- (void)setMiddleTackHeight:(CGFloat)middleTackHeight
{
    progressView.height = middleTackHeight;
}

- (CGFloat)minimumTackHeight
{
    return slider.trackHeight;
}

- (void)setMinimumTackHeight:(CGFloat)minimumTackHeight
{
    slider.trackHeight = minimumTackHeight;
}

- (UIColor *)thumbTintColor
{
    return slider.thumbTintColor;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    [slider setThumbTintColor:thumbTintColor];
}

- (UIColor *)minimumTrackTintColor
{
    return slider.minimumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor
{
    [slider setMinimumTrackTintColor:minimumTrackTintColor];
}

- (UIColor *)middleTrackTintColor
{
    return progressView.progressTintColor;
}

- (void)setMiddleTrackTintColor:(UIColor *)middleTrackTintColor
{
    progressView.progressTintColor = middleTrackTintColor;
}

- (UIColor *)maximumTrackTintColor
{
    return progressView.trackTintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor
{
    progressView.trackTintColor = maximumTrackTintColor;
}

- (UIImage *)thumbImage
{
    return slider.currentThumbImage;
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
    [slider setThumbImage:image forState:state];
}

- (UIImage *)minimumTrackImage
{
    return slider.currentMinimumTrackImage;
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage
{
    [slider setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
}

- (UIImage *)middleTrackImage
{
    return progressView.progressImage;
}

- (void)setMiddleTrackImage:(UIImage *)middleTrackImage
{
    progressView.progressImage = middleTrackImage;
}

- (UIImage *)maximumTrackImage
{
    return progressView.trackImage;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage
{
    [slider setMaximumTrackImage:[UIImage imageWithColor:[UIColor clearColor] size:maximumTrackImage.size] forState:UIControlStateNormal];
    progressView.trackImage = maximumTrackImage;
}

@end
