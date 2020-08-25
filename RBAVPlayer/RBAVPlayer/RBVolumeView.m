//
//  RBVolumeView.m
//  RBAVPlayer
//
//  Created by Robert on 2015/2/9.
//  Copyright (c) 2015年 virentech. All rights reserved.
//

#import "RBVolumeView.h"

@implementation RBVolumeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)volumeSliderRectForBounds:(CGRect)bounds
{
    CGRect rect = [super volumeSliderRectForBounds:bounds];
    rect.origin.y = ((self.frame.size.height - rect.size.height)/2);
    return rect;
}

- (CGRect)routeButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super routeButtonRectForBounds:bounds];
    rect.origin.y = ((self.frame.size.height - rect.size.height)/2);
    return rect;
}

@end
