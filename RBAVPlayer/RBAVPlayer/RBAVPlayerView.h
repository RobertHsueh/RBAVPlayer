//
//  RBAVPlayerView.h
//  RBAVPlayer
//
//  Created by Robert on 2015/1/21.
//  Copyright (c) 2015年 virentech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RBProgressSlider.h"
#import "RBVolumeView.h"

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...) /* */
#endif

@class RBAVPlayerView;

@protocol RBAVPlayerViewDelegate <NSObject>

@optional
- (void)RBAVPlayerViewWillPlay:(RBAVPlayerView *)view;
- (void)RBAVPlayerViewDidPlay:(RBAVPlayerView *)view;
- (void)RBAVPlayerViewWillPause:(RBAVPlayerView *)view;
- (void)RBAVPlayerViewDidPause:(RBAVPlayerView *)view;
- (void)RBAVPlayerViewFinishedPlayback:(RBAVPlayerView *)view;

@end


@interface RBAVPlayerView : UIView

@property (nonatomic, weak) id <RBAVPlayerViewDelegate> delegate;
@property (nonatomic, strong) NSURL *contentURL;
@property (nonatomic, strong) AVPlayer *moviePlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) RBVolumeView *airplayButton;
@property (nonatomic, strong) RBProgressSlider *playerSlider;
@property (nonatomic, strong) UILabel *playBackTimeLabel;
@property (nonatomic, strong) UILabel *playBackTotalTimeLabel;
@property (nonatomic, strong) UIView *playerHudBottom;
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign) BOOL shouldShowHideParentNavigationBar;//default is false
@property (nonatomic, assign) BOOL shouldPlayAudioOnVibrate;//default is false

- (instancetype)initWithFrame:(CGRect)frame contentURL:(NSURL *)contentURL;
- (instancetype)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem *)playerItem;
- (void)play;
- (void)pause;
- (void)endPlayer;
- (void)checkIsPlayable:(NSURL *)url completionHandler:(void (^)(BOOL isPlayable))completion;

@end
