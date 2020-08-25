//
//  RBProgressSlider.h
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

#import <UIKit/UIKit.h>
#import "RBProgressView.h"
#import "RBSlider.h"

// customize UISlider : add middle track to display buffer progress for video or music player.(support UIControlEventValueChanged event)
// reference to :
// https://github.com/smallmuou/YDSlider

@interface RBProgressSlider : UIControl

@property (nonatomic, assign) float value;        /* From 0 to 1 */
@property (nonatomic, assign) float middleValue;  /* From 0 to 1 */
@property (nonatomic, assign) float minimumValue;
@property (nonatomic, assign) float maximumValue;

@property (nonatomic, assign) BOOL middleTackClipsToBounds;//default is true
@property (nonatomic, assign) CGFloat middleTackHeight;//default is 2
@property (nonatomic, assign) CGFloat minimumTackHeight;//default is 3

@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
@property (nonatomic, strong) UIColor *middleTrackTintColor;
@property (nonatomic, strong) UIColor *maximumTrackTintColor;

@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *minimumTrackImage;
@property (nonatomic, strong) UIImage *middleTrackImage;
@property (nonatomic, strong) UIImage *maximumTrackImage;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

@end
