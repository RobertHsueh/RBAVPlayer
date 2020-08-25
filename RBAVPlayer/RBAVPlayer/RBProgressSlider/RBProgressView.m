//
//  RBProgressView.m
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


#import "RBProgressView.h"

@interface RBProgressView ()

@property (nonatomic, weak) UIImageView *trackImageView;
@property (nonatomic, weak) UIImageView *progressImageView;

@end


@implementation RBProgressView


#pragma mark - Initialization

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
    self.height = 2;
    [self setupProgressView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *trackImageView = self.trackImageView;
    UIImageView *progressImageView = self.progressImageView;
    if (!trackImageView || !progressImageView) {
        return;
    }
    
    CGRect bounds = self.bounds;
    CGFloat boundsTop = CGRectGetMinY(bounds);
    UIImage *trackImage = self.trackImage;
    if (trackImage) {
        CGRect trackFrame = trackImageView.frame;
        CGFloat trackHeight = trackImage.size.height;
        trackImageView.frame = CGRectMake(CGRectGetMinX(trackFrame), (boundsTop + ((CGRectGetHeight(bounds) - trackHeight) * 0.5f)), CGRectGetWidth(trackFrame), trackHeight);
    }
    
    UIImage *progressImage = self.progressImage;
    if (progressImage) {
        CGRect progressFrame = progressImageView.frame;
        CGFloat progressHeight = progressImage.size.height;
        progressImageView.frame = CGRectMake(CGRectGetMinX(progressFrame), (boundsTop + ((CGRectGetHeight(bounds) - progressHeight) * 0.5f)), CGRectGetWidth(progressFrame), progressHeight);
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = [super sizeThatFits:size];
    if (_height != 0) {
        newSize.height = _height;
    }
//    NSLog(@"%@" ,[NSValue valueWithCGSize:newSize]);
    return newSize;
}


#pragma mark - UIProgressView

- (void)setProgressImage:(UIImage *)progressImage
{
    [super setProgressImage:progressImage];
    self.progressImageView.image = progressImage;
}

- (void)setTrackImage:(UIImage *)trackImage
{
    [super setTrackImage:trackImage];
    self.trackImageView.image = trackImage;
}


#pragma mark - configuration

- (void)setupProgressView
{
    NSString *version = [NSString stringWithFormat:@"%@" ,[UIDevice currentDevice].systemVersion];
    if ([version compare:@"7.1" options:NSNumericSearch] == NSOrderedAscending) {
        return;
    }
    NSArray *subviews = self.subviews;
    if ([subviews count] != 2) {
        return;
    }
    
    for (UIView *subview in subviews) {
        if (![subview isKindOfClass:[UIImageView class]]) {
            return;
        }
    }
    
    self.trackImageView = subviews[0];
    self.progressImageView = subviews[1];
    
    self.trackImageView.image = self.trackImage;
    self.progressImageView.image = self.progressImage;
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    [self sizeToFit];
}

//- (NSComparisonResult)compareVersionString:(NSString *)versionString1 withVersionString:(NSString *)versionString2
//{
//    NSArray *components1 = [versionString1 componentsSeparatedByString:@"."];
//    NSArray *components2 = [versionString2 componentsSeparatedByString:@"."];
//    
//    NSUInteger components1Count = [components1 count];
//    NSUInteger components2Count = [components2 count];
//    NSUInteger partCount = MAX(components1Count, components2Count);
//    
//    for (NSInteger part = 0; part < partCount; ++part) {
//        
//        if (part >= components1Count) {
//            return NSOrderedAscending;
//        }
//        
//        if (part >= components2Count) {
//            return NSOrderedDescending;
//        }
//        
//        NSString *part1String = components1[part];
//        NSString *part2String = components2[part];
//        NSInteger part1 = [part1String integerValue];
//        NSInteger part2 = [part2String integerValue];
//        
//        if (part1 > part2) {
//            return NSOrderedDescending;
//        }
//        
//        if (part1 < part2) {
//            return NSOrderedAscending;
//        }
//    }
//    return NSOrderedSame;
//}


@end
