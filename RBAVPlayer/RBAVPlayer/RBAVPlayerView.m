//
//  RBAVPlayerView.m
//  RBAVPlayer
//
//  Created by Robert on 2015/1/21.
//  Copyright (c) 2015年 virentech. All rights reserved.
//

#import "RBAVPlayerView.h"

const static int kPlayerHudBottomHeight = 34;
const static int kPlayerHudBottomItemFrame = 32;
const static int kPlayerHudBottomItemYPadding = 1;
const static CGFloat kTimeLabelFontSize = 20.0;

const static int kPlayPauseButtonLeftPadding = 2;
const static int kPlayPauseButtonRightPadding = 1;
const static int kPlayBackTimeLabelLeftPadding = 1;
const static int kPlayBackTimeLabelRightPadding = 1;
const static int kPlayerSliderLeftPadding = 1;
const static int kPlayerSliderRightPadding = 1;
const static int kPlayBackTotalTimeLabelLeftPadding = 1;
const static int kPlayBackTotalTimeLabelRightPadding = 1;
const static int kFullScreenButtonLeftPadding = 1;
const static int kFullScreenButtonRightPadding = 1;
const static int kAirplayButtonLeftPadding = 1;
const static int kAirplayButtonRightPadding = 1;

const static int kAirplayStatusIconBottomPadding = 5;
const static int kAirplayStatusLabelTopPadding = 5;
const static int kAirplayStatusLabelLeftPadding = 30;
const static int kAirplayStatusLabelRightPadding = 30;
const static int kAirplayStatusLabelHeight = 50;
const static CGFloat kAirplayStatusFontSize = 15.0;
const static CGFloat kAirplayStatusIconFrame = 45.0;

//const static int kPlayerHudTopHeight = 34;
//const static int kPlayerHudTopItemFrame = 24;
//const static int kPlayerHudTopItemYPadding = 5;
//const static CGFloat kTitleLabelFontSize = 20.0;
//
//const static int kBackHomeButtonLeftPadding = 4;
//const static int kBackHomeButtonRightPadding = 2;
//const static int kPlayerTitleLabelLeftPadding = 2;
//const static int kPlayerTitleLabelRightPadding = 2;
//const static int kPopScrollViewButtonLeftPadding = 2;
//const static int kPopScrollViewButtonRightPadding = 2;
//const static int kWritePopScrollLabelButtonLeftPadding = 2;
//const static int kWritePopScrollLabelButtonRightPadding = 4;

@interface RBAVPlayerView ()
{
//    AVPlayerItem *playerItem;
    AVPlayerLayer *playerLayer;
//    AVAsset *movieAsset;
    UIActivityIndicatorView *activityIndicator;
    UIView *airPlayStatusView;
    UIImageView *airPlayIcon;
    UILabel *airplayDeviceLabel;
    id playbackObserver;
    BOOL isHudViewShowing;
    float timeLabelWidth;
    float timeLabelHeight;
    int airplayButtonFrame;
    double totalMovieDuration;
    BOOL isNotFirstPlay;
    BOOL isBufferPause;
    AVAsset *assetForTest;
}
@end

@implementation RBAVPlayerView

#pragma mark - AVPlayerLayer setup

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

/* Specifies how the video is displayed within a player layer’s bounds.
 (AVLayerVideoGravityResizeAspect is default) */
- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *avPlayerLayer = (AVPlayerLayer *)[self layer];
    avPlayerLayer.videoGravity = fillMode;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (self.shouldShowHideParentNavigationBar && self.shouldShowPlayerHudTop) {
//        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
//        }else if (![[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:YES animated:YES];
//        }
//    }else if (self.shouldShowHideParentNavigationBar && !self.shouldShowPlayerHudTop) {
//        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
//        }
//    }else if (!self.shouldShowHideParentNavigationBar && self.shouldShowPlayerHudTop) {
//        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
//        }else if (![[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:YES animated:YES];
//        }
//    }
    if (self.shouldShowHideParentNavigationBar) {
        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
        }
//        else if (![[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:YES animated:YES];
//        }
    }
//    else if (self.shouldShowHideParentNavigationBar && !self.shouldShowPlayerHudTop) {
//        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
//        }
//    }
//    else if (!self.shouldShowHideParentNavigationBar && self.shouldShowPlayerHudTop) {
//        if ([[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:NO animated:YES];
//        }else if (![[self superviewNavigationController] isNavigationBarHidden] && (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))) {
//            [[self superviewNavigationController] setNavigationBarHidden:YES animated:YES];
//        }
//    }
}


#pragma mark - Initializers/deallocator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializePlayerAtFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem *)aPlayerItem
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlayerWithPlayerItem:aPlayerItem forFrame:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame contentURL:(NSURL *)contentURL
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlayerWithURL:contentURL forFrame:frame];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"RBAVPlayer - dealloc");
    [self.moviePlayer removeTimeObserver:playbackObserver];
    [self unregisterObservers];
    self.moviePlayer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Player setup methods

- (void)setupPlayerWithURL:(NSURL *)theURL forFrame:(CGRect)aFrame
{
    if (self.contentURL) {
        self.contentURL = nil;
    }
    AVPlayerItem *aPlayerItem = [AVPlayerItem playerItemWithURL:theURL];
    self.contentURL = theURL;
    [self setupPlayerWithPlayerItem:aPlayerItem forFrame:aFrame];
}

- (void)setupPlayerWithPlayerItem:(AVPlayerItem *)aPlayerItem forFrame:(CGRect)aFrame
{
    // defensively remote observers, notifications
    [self unregisterObservers];
    
    if (self.moviePlayer) {
        self.moviePlayer = nil;
    }
    if (playerLayer) {
        playerLayer = nil;
    }
    if (self.playerItem) {
        self.playerItem = nil;
    }
    
    self.playerItem = aPlayerItem;
    self.moviePlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    [playerLayer setFrame:aFrame];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self setPlayer:self.moviePlayer];
    [self setVideoFillMode:AVLayerVideoGravityResizeAspect];
    self.contentURL = nil;
    
    [self initializePlayerAtFrame:aFrame];
    [self registerObservers];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [playerLayer setFrame:frame];
    [self resetAllUILayout:frame];
}


#pragma mark - Player UI setup

- (void)initializePlayerAtFrame:(CGRect)frame
{
    float playerFrameWidth =  frame.size.width;
    float playerFrameHeight = frame.size.height;
    
    self.backgroundColor = [UIColor blackColor];
    isHudViewShowing =  NO;
    
    [self.layer setMasksToBounds:YES];
    
    //air play status view
    airPlayStatusView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:airPlayStatusView];
    
    //air play icon
    CGFloat airPlayIconX = ((playerFrameWidth/2) - (kAirplayStatusIconFrame/2));
    CGFloat airPlayIconY = (playerFrameHeight-kAirplayStatusIconFrame-kAirplayStatusIconBottomPadding-kAirplayStatusLabelTopPadding-kAirplayStatusLabelHeight)/2;
    CGFloat airPlayIconWidth = kAirplayStatusIconFrame;
    CGFloat airPlayIconHeight = kAirplayStatusIconFrame;
    airPlayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(airPlayIconX, airPlayIconY, airPlayIconWidth, airPlayIconHeight)];
    airPlayIcon.image = [UIImage imageNamed:@"playback_airplay"];
    [airPlayStatusView addSubview:airPlayIcon];
    
    //air play label
    CGFloat airplayDeviceLabelX = kAirplayStatusLabelLeftPadding;
//    CGFloat airplayDeviceLabelY = kAirplayStatusIconTopPadding+kAirplayStatusIconFrame+kAirplayStatusIconBottomPadding+kAirplayStatusLabelTopPadding;
    CGFloat airplayDeviceLabelY = airPlayIconY+kAirplayStatusIconFrame+kAirplayStatusIconBottomPadding+kAirplayStatusLabelTopPadding;
    CGFloat airplayDeviceLabelWidth = playerFrameWidth - kAirplayStatusLabelLeftPadding - kAirplayStatusLabelRightPadding;
//    CGFloat airplayDeviceLabelHeight = playerFrameHeight - airplayDeviceLabelY - kAirplayStatusLabelBottomPadding;
    CGFloat airplayDeviceLabelHeight = kAirplayStatusLabelHeight;
    airplayDeviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(airplayDeviceLabelX, airplayDeviceLabelY, airplayDeviceLabelWidth, airplayDeviceLabelHeight)];
    airplayDeviceLabel.textAlignment = NSTextAlignmentCenter;
    airplayDeviceLabel.numberOfLines = 0;
    airplayDeviceLabel.font = [UIFont systemFontOfSize:kAirplayStatusFontSize];
    airplayDeviceLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [airPlayStatusView addSubview:airplayDeviceLabel];
    
    //scroll label view
//    self.scrollLabelView = [[RBScrollLabelView alloc] initWithFrame:self.frame];
//    [self addSubview:self.scrollLabelView];
    
//    //player Hud top
//    self.playerHudTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, playerFrameWidth, kPlayerHudTopHeight)];
//    self.playerHudTop.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:0.5f];
//    [self addSubview:self.playerHudTop];
//    
//    //back home button
//    self.backHomeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.backHomeButton.frame = CGRectMake(kBackHomeButtonLeftPadding, kPlayerHudTopItemYPadding, kPlayerHudTopItemFrame, kPlayerHudTopItemFrame);
//    [self.backHomeButton addTarget:self action:@selector(backHomeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.backHomeButton setBackgroundImage:[UIImage imageNamed:@"back_a"] forState:UIControlStateNormal];
//    [self.playerHudTop addSubview:self.backHomeButton];
//    
//    //player title label
//    CGFloat playerTitleLabelX = kBackHomeButtonLeftPadding+kPlayerHudTopItemFrame+kBackHomeButtonRightPadding+kPlayerTitleLabelLeftPadding;
//    CGFloat playerTitleLabelY = kPlayerHudTopItemYPadding;
//    CGFloat playerTitleLabelWidth = playerFrameWidth-playerTitleLabelX-kPlayerTitleLabelRightPadding-kPopScrollViewButtonLeftPadding-kPlayerHudTopItemFrame-kPopScrollViewButtonRightPadding-kWritePopScrollLabelButtonLeftPadding-kPlayerHudTopItemFrame-kWritePopScrollLabelButtonRightPadding;
//    CGFloat playerTitleLabelHeight = kPlayerHudTopItemFrame;
//    self.playerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(playerTitleLabelX, playerTitleLabelY, playerTitleLabelWidth, playerTitleLabelHeight)];
//    self.playerTitleLabel.textAlignment = NSTextAlignmentCenter;
//    self.playerTitleLabel.textColor = [UIColor orangeColor];
//    self.playerTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
//    [self.playerHudTop addSubview:self.playerTitleLabel];
    
//    //pop scroll view button
//    CGFloat popScrollViewButtonX = playerFrameWidth-kPlayerHudTopItemFrame-kPopScrollViewButtonRightPadding-kWritePopScrollLabelButtonLeftPadding-kPlayerHudTopItemFrame-kWritePopScrollLabelButtonRightPadding;
//    CGFloat popScrollViewButtonY = kPlayerHudTopItemYPadding;
//    CGFloat popScrollViewButtonWidth = kPlayerHudTopItemFrame;
//    CGFloat popScrollViewButtonHeight = kPlayerHudTopItemFrame;
//    self.popScrollViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.popScrollViewButton.frame = CGRectMake(popScrollViewButtonX, popScrollViewButtonY, popScrollViewButtonWidth, popScrollViewButtonHeight);
//    [self.popScrollViewButton addTarget:self action:@selector(popScrollViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.popScrollViewButton setBackgroundImage:[UIImage imageNamed:@"popScrollViewIcon"] forState:UIControlStateNormal];
//    [self.playerHudTop addSubview:self.popScrollViewButton];
//    
//    //write pop scroll label button
//    CGFloat writePopScrollLabelButtonX = playerFrameWidth-kPlayerHudTopItemFrame-kWritePopScrollLabelButtonRightPadding;
//    CGFloat writePopScrollLabelButtonY = kPlayerHudTopItemYPadding;
//    CGFloat writePopScrollLabelButtonWidth = kPlayerHudTopItemFrame;
//    CGFloat writePopScrollLabelButtonHeight = kPlayerHudTopItemFrame;
//    self.writePopScrollLabelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.writePopScrollLabelButton.frame = CGRectMake(writePopScrollLabelButtonX, writePopScrollLabelButtonY, writePopScrollLabelButtonWidth, writePopScrollLabelButtonHeight);
//    [self.writePopScrollLabelButton addTarget:self action:@selector(writePopScrollLabelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.writePopScrollLabelButton setBackgroundImage:[UIImage imageNamed:@"CreateNew"] forState:UIControlStateNormal];
//    [self.playerHudTop addSubview:self.writePopScrollLabelButton];
    
    //player Hud Bottom
    self.playerHudBottom = [[UIView alloc] initWithFrame:CGRectMake(0, playerFrameHeight-kPlayerHudBottomHeight, playerFrameWidth, kPlayerHudBottomHeight)];
    self.playerHudBottom.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:0.5f];
    [self addSubview:self.playerHudBottom];
    
    //Play/pause button
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.playPauseButton.frame = CGRectMake(5*playerFrameWidth/240, 6*playerFrameHeight/160, 16*playerFrameWidth/240, 16*playerFrameHeight/160);
    self.playPauseButton.frame = CGRectMake(kPlayPauseButtonLeftPadding, kPlayerHudBottomItemYPadding, kPlayerHudBottomItemFrame, kPlayerHudBottomItemFrame);
    [self.playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.playPauseButton setSelected:NO];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"btn_pause_playback"] forState:UIControlStateSelected];//btn_small_pause
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"btn_play_playback"] forState:UIControlStateNormal];//btn_small_play
    [self.playPauseButton setTintColor:[UIColor clearColor]];
    [self.playerHudBottom addSubview:self.playPauseButton];
    
    //Calculate appropriately sized font
//    CGFloat maxFontSize = MIN(12 * playerFrameWidth/240, 15.0);
    
    NSMutableParagraphStyle *stringParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    stringParagraphStyle.lineBreakMode = NSLineBreakByClipping;
    NSDictionary *stringAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:kTimeLabelFontSize], NSParagraphStyleAttributeName : stringParagraphStyle};
    CGSize stringSize = [@"000:00" sizeWithAttributes:stringAttributes];
    timeLabelWidth = ceilf(stringSize.width);
    timeLabelHeight = ceilf(stringSize.height);
    
    //Current time label
    self.playBackTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPlayPauseButtonLeftPadding+kPlayerHudBottomItemFrame+kPlayPauseButtonRightPadding, (kPlayerHudBottomHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight)];
    self.playBackTimeLabel.text = [self getStringFromCMTime:self.moviePlayer.currentTime];
    [self.playBackTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.playBackTimeLabel setTextColor:[UIColor blackColor]];//whiteColor
    self.playBackTimeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
//    [self.playBackTimeLabel sizeToFit];
    [self.playerHudBottom addSubview:self.playBackTimeLabel];
    
    //RBProgressSlider = scrubber
    CGFloat playerSliderX = kPlayPauseButtonLeftPadding+kPlayerHudBottomItemFrame+kPlayPauseButtonRightPadding+kPlayBackTimeLabelLeftPadding+timeLabelWidth+kPlayBackTimeLabelRightPadding+kPlayerSliderLeftPadding;
    CGFloat playerSliderY = 0;
    CGFloat playerSliderWidth = self.frame.size.width - (playerSliderX+kPlayerSliderRightPadding+kPlayBackTotalTimeLabelLeftPadding+timeLabelWidth+kPlayBackTotalTimeLabelRightPadding+kFullScreenButtonLeftPadding+kPlayerHudBottomItemFrame+kFullScreenButtonRightPadding+kAirplayButtonLeftPadding+airplayButtonFrame+kAirplayButtonRightPadding);
    CGFloat playerSliderHeight = kPlayerHudBottomItemFrame;
    _playerSlider = [[RBProgressSlider alloc] initWithFrame:CGRectMake(playerSliderX, playerSliderY, playerSliderWidth, playerSliderHeight)];
    [_playerSlider addTarget:self action:@selector(playSliderIsSliding:) forControlEvents:UIControlEventValueChanged];
    [_playerSlider addTarget:self action:@selector(playSliderClicked:) forControlEvents:UIControlEventTouchUpInside];
    _playerSlider.minimumTrackTintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    _playerSlider.middleTrackTintColor = [UIColor whiteColor];
    [self.playerHudBottom addSubview:_playerSlider];
    
    //Total time label
    CGFloat playBackTotalTimeLabelX = playerSliderX+playerSliderWidth+kPlayerSliderRightPadding+kPlayBackTotalTimeLabelLeftPadding;
    self.playBackTotalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(playBackTotalTimeLabelX, (kPlayerHudBottomHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight)];
    self.playBackTotalTimeLabel.text = [self getStringFromCMTime:self.moviePlayer.currentItem.asset.duration];
    [self.playBackTotalTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.playBackTotalTimeLabel setTextColor:[UIColor blackColor]];//whiteColor
    self.playBackTotalTimeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
//    [self.playBackTotalTimeLabel sizeToFit];
    [self.playerHudBottom addSubview:self.playBackTotalTimeLabel];
    
    //full Screen Button
    CGFloat fullScreenButtonX = playBackTotalTimeLabelX + timeLabelWidth + kPlayBackTotalTimeLabelRightPadding + kFullScreenButtonLeftPadding;
    self.fullScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.fullScreenButton.frame = CGRectMake(fullScreenButtonX, kPlayerHudBottomItemYPadding, kPlayerHudBottomItemFrame, kPlayerHudBottomItemFrame);
    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenButton setSelected:NO];
//    [self.fullScreenButton setBackgroundImage:[UIImage imageNamed:@"zoomout"] forState:UIControlStateSelected];
    [self.fullScreenButton setBackgroundImage:[UIImage imageNamed:@"btn_fullversion_playback"] forState:UIControlStateNormal];//zoomin
//    [self.fullScreenButton setTintColor:[UIColor orangeColor]];
//    [self.fullScreenButton setBackgroundColor:[UIColor yellowColor]];
//    self.fullScreenButton.layer.opacity = 0;
    [self.playerHudBottom addSubview:self.fullScreenButton];
    
    //AirPlay button
    CGFloat airplayButtonX = fullScreenButtonX + kPlayerHudBottomItemFrame + kAirplayButtonLeftPadding;
    self.airplayButton = [[RBVolumeView alloc] initWithFrame:CGRectMake(airplayButtonX, kPlayerHudBottomItemYPadding, airplayButtonFrame, airplayButtonFrame)];
    [self.airplayButton setShowsVolumeSlider:NO];
    [self.airplayButton sizeToFit];
    [self.playerHudBottom addSubview:self.airplayButton];
    self.airplayButton.hidden = YES;
//    self.airplayButton.backgroundColor = [UIColor redColor];
    
    CMTime interval = CMTimeMake(33, 100);
    __weak __typeof(self) weakself = self;
    playbackObserver = [self.moviePlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        Float64 currentSeconds = CMTimeGetSeconds(weakself.moviePlayer.currentTime);
        Float64 durationSeconds = CMTimeGetSeconds(weakself.moviePlayer.currentItem.asset.duration);
//        CMTime endTime = CMTimeConvertScale (weakself.moviePlayer.currentItem.asset.duration, weakself.moviePlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
//        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
//            double normalizedTime = (double) weakself.moviePlayer.currentTime.value / (double) endTime.value;
//            weakself.playerSlider.value = normalizedTime;
//        }
//        weakself.playBackTimeLabel.text = [weakself getStringFromCMTime:weakself.moviePlayer.currentTime];
        weakself.playerSlider.value = currentSeconds;
        weakself.playBackTimeLabel.text = [weakself getStringFromSecond:currentSeconds];
        weakself.playBackTotalTimeLabel.text = [weakself getStringFromSecond:durationSeconds-currentSeconds];
    }];
    
    airPlayStatusView.hidden = true;
//    self.shouldShowPlayerHudTop = false;
    [self showHUD:YES];
    [self showActivityIndicator:true];
    
    // check for AirPlay with slight delay
    float statusDelay = 1.0;
    __weak RBAVPlayerView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(statusDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.airplayButton.wirelessRouteActive) {
            [weakSelf showAirPlayIconWithOutputName:[weakSelf activeAirPlayOutputRouteName]];
        }
    });
    
//    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    stopButton.frame = CGRectMake(0, 0, 100, 60);
//    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
//    [stopButton addTarget:self action:@selector(stopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    stopButton.backgroundColor = [UIColor orangeColor];
//    [self addSubview:stopButton];
}

//- (void)stopButtonClicked:(UIButton *)sender
//{
//    
//}

- (void)resetAllUILayout:(CGRect)frame
{
    float playerFrameWidth =  frame.size.width;
    float playerFrameHeight = frame.size.height;
    
    //air play status view
    airPlayStatusView.frame = frame;
    
    //air play icon
    CGFloat airPlayIconX = ((playerFrameWidth/2) - (kAirplayStatusIconFrame/2));
    CGFloat airPlayIconY = (playerFrameHeight-kAirplayStatusIconFrame-kAirplayStatusIconBottomPadding-kAirplayStatusLabelTopPadding-kAirplayStatusLabelHeight)/2;
    CGFloat airPlayIconWidth = kAirplayStatusIconFrame;
    CGFloat airPlayIconHeight = kAirplayStatusIconFrame;
    airPlayIcon.frame = CGRectMake(airPlayIconX, airPlayIconY, airPlayIconWidth, airPlayIconHeight);
    
    //air play label
    CGFloat airplayDeviceLabelX = kAirplayStatusLabelLeftPadding;
//    CGFloat airplayDeviceLabelY = kAirplayStatusIconTopPadding+kAirplayStatusIconFrame+kAirplayStatusIconBottomPadding+kAirplayStatusLabelTopPadding;
    CGFloat airplayDeviceLabelY = airPlayIconY+kAirplayStatusIconFrame+kAirplayStatusIconBottomPadding+kAirplayStatusLabelTopPadding;
    CGFloat airplayDeviceLabelWidth = playerFrameWidth - kAirplayStatusLabelLeftPadding - kAirplayStatusLabelRightPadding;
//    CGFloat airplayDeviceLabelHeight = playerFrameHeight - airplayDeviceLabelY - kAirplayStatusLabelBottomPadding;
    CGFloat airplayDeviceLabelHeight = kAirplayStatusLabelHeight;
    airplayDeviceLabel.frame = CGRectMake(airplayDeviceLabelX, airplayDeviceLabelY, airplayDeviceLabelWidth, airplayDeviceLabelHeight);
    
    //scroll label view
//    [self.scrollLabelView setFrame:frame];
//    self.playPauseButton.frame = CGRectMake(kPlayPauseButtonLeftPadding, kPlayerHudBottomItemYPadding, kPlayerHudBottomItemFrame, kPlayerHudBottomItemFrame);
    
    //Activity Indicator
    activityIndicator.center = CGPointMake(playerFrameWidth/2, playerFrameHeight/2);
    
//    //player Hud top
//    if (self.shouldShowPlayerHudTop) {
//        self.playerHudTop.frame = CGRectMake(0, 0, playerFrameWidth, kPlayerHudTopHeight);
//    }else {
//        self.playerHudTop.frame = CGRectMake(0, -kPlayerHudTopHeight, playerFrameWidth, kPlayerHudTopHeight);
//    }
//    
//    //back home button
//    self.backHomeButton.frame = CGRectMake(kBackHomeButtonLeftPadding, kPlayerHudTopItemYPadding, kPlayerHudTopItemFrame, kPlayerHudTopItemFrame);
//    
//    //player title label
//    CGFloat playerTitleLabelX = kBackHomeButtonLeftPadding+kPlayerHudTopItemFrame+kBackHomeButtonRightPadding+kPlayerTitleLabelLeftPadding;
//    CGFloat playerTitleLabelY = kPlayerHudTopItemYPadding;
//    CGFloat playerTitleLabelWidth = playerFrameWidth-playerTitleLabelX-kPlayerTitleLabelRightPadding-kPopScrollViewButtonLeftPadding-kPlayerHudTopItemFrame-kPopScrollViewButtonRightPadding-kWritePopScrollLabelButtonLeftPadding-kPlayerHudTopItemFrame-kWritePopScrollLabelButtonRightPadding;
//    CGFloat playerTitleLabelHeight = kPlayerHudTopItemFrame;
//    self.playerTitleLabel.frame = CGRectMake(playerTitleLabelX, playerTitleLabelY, playerTitleLabelWidth, playerTitleLabelHeight);
    
//    //pop scroll view button
//    CGFloat popScrollViewButtonX = playerFrameWidth-kPlayerHudTopItemFrame-kPopScrollViewButtonRightPadding-kWritePopScrollLabelButtonLeftPadding-kPlayerHudTopItemFrame-kWritePopScrollLabelButtonRightPadding;
//    CGFloat popScrollViewButtonY = kPlayerHudTopItemYPadding;
//    CGFloat popScrollViewButtonWidth = kPlayerHudTopItemFrame;
//    CGFloat popScrollViewButtonHeight = kPlayerHudTopItemFrame;
//    self.popScrollViewButton.frame = CGRectMake(popScrollViewButtonX, popScrollViewButtonY, popScrollViewButtonWidth, popScrollViewButtonHeight);
//    
//    //write pop scroll label button
//    CGFloat writePopScrollLabelButtonX = playerFrameWidth-kPlayerHudTopItemFrame-kWritePopScrollLabelButtonRightPadding;
//    CGFloat writePopScrollLabelButtonY = kPlayerHudTopItemYPadding;
//    CGFloat writePopScrollLabelButtonWidth = kPlayerHudTopItemFrame;
//    CGFloat writePopScrollLabelButtonHeight = kPlayerHudTopItemFrame;
//    self.writePopScrollLabelButton.frame = CGRectMake(writePopScrollLabelButtonX, writePopScrollLabelButtonY, writePopScrollLabelButtonWidth, writePopScrollLabelButtonHeight);
    
    [self resetHudBottomUILayout:frame];
}

- (void)resetHudBottomUILayout:(CGRect)frame
{
    float playerFrameWidth =  frame.size.width;
    float playerFrameHeight = frame.size.height;
    
    //player Hud Bottom
    self.playerHudBottom.frame = CGRectMake(0, playerFrameHeight-kPlayerHudBottomHeight, playerFrameWidth, kPlayerHudBottomHeight);
    
    //Play/pause button
    self.playPauseButton.frame = CGRectMake(kPlayPauseButtonLeftPadding, kPlayerHudBottomItemYPadding, kPlayerHudBottomItemFrame, kPlayerHudBottomItemFrame);
    
    //play back time label
    self.playBackTimeLabel.frame = CGRectMake(kPlayPauseButtonLeftPadding+kPlayerHudBottomItemFrame+kPlayPauseButtonRightPadding, (kPlayerHudBottomHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight);
    
    //RBProgressSlider = scrubber
    CGFloat playerSliderX = kPlayPauseButtonLeftPadding+kPlayerHudBottomItemFrame+kPlayPauseButtonRightPadding+kPlayBackTimeLabelLeftPadding+timeLabelWidth+kPlayBackTimeLabelRightPadding+kPlayerSliderLeftPadding;
    CGFloat playerSliderY = 0;
    CGFloat playerSliderWidth = self.frame.size.width - (playerSliderX+kPlayerSliderRightPadding+kPlayBackTotalTimeLabelLeftPadding+timeLabelWidth+kPlayBackTotalTimeLabelRightPadding+kFullScreenButtonLeftPadding+kPlayerHudBottomItemFrame+kFullScreenButtonRightPadding+kAirplayButtonLeftPadding+airplayButtonFrame+kAirplayButtonRightPadding);
    CGFloat playerSliderHeight = kPlayerHudBottomItemFrame;
    self.playerSlider.frame = CGRectMake(playerSliderX, playerSliderY, playerSliderWidth, playerSliderHeight);
    
    //Total time label
    CGFloat playBackTotalTimeLabelX = playerSliderX+playerSliderWidth+kPlayerSliderRightPadding+kPlayBackTotalTimeLabelLeftPadding;
    self.playBackTotalTimeLabel.frame = CGRectMake(playBackTotalTimeLabelX, (kPlayerHudBottomHeight-timeLabelHeight)/2, timeLabelWidth, timeLabelHeight);
    
    //full Screen Button
    CGFloat fullScreenButtonX = playBackTotalTimeLabelX + timeLabelWidth + kPlayBackTotalTimeLabelRightPadding + kFullScreenButtonLeftPadding;
    self.fullScreenButton.frame = CGRectMake(fullScreenButtonX, kPlayerHudBottomItemYPadding, kPlayerHudBottomItemFrame, kPlayerHudBottomItemFrame);
    
    //AirPlay button
    CGFloat airplayButtonX = fullScreenButtonX + kPlayerHudBottomItemFrame + kAirplayButtonLeftPadding;
    self.airplayButton.frame = CGRectMake(airplayButtonX, kPlayerHudBottomItemYPadding, airplayButtonFrame, airplayButtonFrame);
}

- (NSTimeInterval)availableDuration;
{
    NSArray *loadedTimeRanges = [[self.moviePlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
    double startSeconds = CMTimeGetSeconds(timeRange.start);
    double durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    //    NSLog(@"totalMovieDuration=%f ,result= %f = %f + %f" ,totalMovieDuration ,result ,startSeconds ,durationSeconds);
    return result;
}

//- (void)setShouldShowPlayerHudTop:(BOOL)shouldShowPlayerHudTop
//{
//    _shouldShowPlayerHudTop = shouldShowPlayerHudTop;
//    if (shouldShowPlayerHudTop) {
//        CGRect frameTop = self.playerHudTop.frame;
//        frameTop.origin.y = 0;
//        self.playerHudTop.frame = frameTop;
//    }else {
//        CGRect frameTop = self.playerHudTop.frame;
//        frameTop.origin.y = -kPlayerHudTopHeight;
//        self.playerHudTop.frame = frameTop;
//    }
//}


#pragma mark - RBProgressSlider Method

- (void)playSliderClicked:(RBProgressSlider *)sender
{
    
}

- (void)playSliderIsSliding:(RBProgressSlider *)sender
{
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
    int nowSeconds = sender.value;
    CMTime nowTime = self.playerItem.duration;
    nowTime.value = nowSeconds * nowTime.timescale;
    //    [playerView.player seekToTime:nowTime completionHandler:^(BOOL finished) {
    //        if (finished) {
    //            if (isPlaying) {
    //                isPlaying = false;
    //                [self playButtonClicked:playButton];
    //            }
    //        }
    //    }];
    [self.moviePlayer seekToTime:nowTime toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30) completionHandler:^(BOOL finished) {
        if (finished) {
            if (self.isPlaying) {
                [self.moviePlayer play];
            }
        }
    }];
}


#pragma mark - Play/pause button handling

//- (void)backHomeButtonClicked:(UIButton *)sender
//{
//    NSLog(@"backHomeButtonClicked");
//    if ([_delegate respondsToSelector:@selector(RBAVPlayerViewBackHomeButtonClicked:)]) {
//        [_delegate RBAVPlayerViewBackHomeButtonClicked:self];
//    }
//}

//- (void)popScrollViewButtonClicked:(UIButton *)sender
//{
//    NSLog(@"popScrollViewButtonClicked");
////    if (self.scrollLabelView.hidden) {
////        self.scrollLabelView.hidden = false;
////    }else {
////        self.scrollLabelView.hidden = true;
////    }
//}
//
//- (void)writePopScrollLabelButtonClicked:(UIButton *)sender
//{
//    NSLog(@"writePopScrollLabelButtonClicked");
//    if ([_delegate respondsToSelector:@selector(RBAVPlayerViewWritePopScrollLabelButtonClicked:)]) {
//        [_delegate RBAVPlayerViewWritePopScrollLabelButtonClicked:self];
//    }
//}

- (void)playPauseButtonClicked:(UIButton *)sender
{
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)play
{
    if ([self.delegate respondsToSelector:@selector(RBAVPlayerViewWillPlay:)]) {
        [self.delegate RBAVPlayerViewWillPlay:self];
    }
    [self.moviePlayer play];
    _isPlaying = YES;
    [self.playPauseButton setSelected:YES];
    if ([self.delegate respondsToSelector:@selector(RBAVPlayerViewDidPlay:)]) {
        [self.delegate RBAVPlayerViewDidPlay:self];
    }
}

- (void)pause
{
    if ([self.delegate respondsToSelector:@selector(RBAVPlayerViewWillPause:)]) {
        [self.delegate RBAVPlayerViewWillPause:self];
    }
    [self.moviePlayer pause];
    _isPlaying = NO;
    [self.playPauseButton setSelected:NO];
    if ([self.delegate respondsToSelector:@selector(RBAVPlayerViewDidPause:)]) {
        [self.delegate RBAVPlayerViewDidPause:self];
    }
}

- (void)endPlayer
{
    [self.moviePlayer pause];
    self.moviePlayer.rate = 0.0;
    _isPlaying = NO;
    [playerLayer removeFromSuperlayer];
//    self.moviePlayer = nil;
}

- (void)playerFinishedPlaying
{
    [self.moviePlayer pause];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.playPauseButton setSelected:NO];
    _isPlaying = NO;
    if ([self.delegate respondsToSelector:@selector(RBAVPlayerViewFinishedPlayback:)]) {
        [self.delegate RBAVPlayerViewFinishedPlayback:self];
    }
}

- (void)fullScreenButtonClicked:(UIButton *)sender
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        if (orientation == UIInterfaceOrientationPortrait) {
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }
    }else {
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }
    }
}


#pragma mark - Touch Enent

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(playerLayer.frame, point)) {
        [self showHUD:!isHudViewShowing];
    }
}

- (void)showHUD:(BOOL)show
{
    float animationTimeInterval = 0.3;
    __weak __typeof(self) weakself = self;
    if (!show) {
        CGRect frameBottom = self.playerHudBottom.frame;
        frameBottom.origin.y = self.bounds.size.height;
        
//        CGRect frameTop = self.playerHudTop.frame;
//        frameTop.origin.y = -kPlayerHudTopHeight;
        
        [UIView animateWithDuration:animationTimeInterval animations:^{
            weakself.playerHudBottom.frame = frameBottom;
//            if (weakself.shouldShowPlayerHudTop) {
//                weakself.playerHudTop.frame = frameTop;
//            }
            isHudViewShowing = show;
        }];
    }else {
        CGRect frameBottom = self.playerHudBottom.frame;
        frameBottom.origin.y = self.bounds.size.height - self.playerHudBottom.frame.size.height;
        
//        CGRect frameTop = self.playerHudTop.frame;
//        frameTop.origin.y = 0;
        
        [UIView animateWithDuration:animationTimeInterval animations:^{
            weakself.playerHudBottom.frame = frameBottom;
//            if (weakself.shouldShowPlayerHudTop) {
//                weakself.playerHudTop.frame = frameTop;
//            }
            isHudViewShowing = show;
        }];
    }
    //show/hide parentViewController's navigationBar alongside HUD
//    if (self.shouldShowHideParentNavigationBar && !self.shouldShowPlayerHudTop) {
//        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
//            [[self superviewNavigationController] setNavigationBarHidden:!show animated:YES];
//        }
//    }
    if (self.shouldShowHideParentNavigationBar) {
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [[self superviewNavigationController] setNavigationBarHidden:!show animated:YES];
        }
    }
}

- (UINavigationController *)superviewNavigationController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark - Time to String Convenience Methods

- (NSString *)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

- (NSString *)getStringFromSecond:(Float64)seconds
{
    int mins = seconds/60.0;
    int secs = fmodf(seconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}


#pragma mark - Audio/vibrate override

- (void)setShouldPlayAudioOnVibrate:(BOOL)shouldPlayAudioOnVibrate
{
    _shouldPlayAudioOnVibrate = shouldPlayAudioOnVibrate;
    NSError *error = nil;
    if (shouldPlayAudioOnVibrate) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
    }else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
    }
    // error handling
    if (error) {
        NSLog(@"%s: error while setting audio vibrate overwrite - %@", __func__, [error localizedDescription]);
    }
}


#pragma mark - ActivityIndicator

- (void)showActivityIndicator:(BOOL)show
{
    if (show) {
        if (!activityIndicator) {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [activityIndicator startAnimating];
//            activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
            activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            [self addSubview:activityIndicator];
        }else {
            activityIndicator.alpha = 1.0;
            [self bringSubviewToFront:activityIndicator];
            if (![activityIndicator isAnimating]) {
                [activityIndicator startAnimating];
            }
        }
    }else {
        if (activityIndicator) {
            [UIView animateWithDuration:0.5 animations:^{
                activityIndicator.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self sendSubviewToBack:activityIndicator];
                if ([activityIndicator isAnimating]) {
                    [activityIndicator stopAnimating];
                }
            }];
        }
    }
}


#pragma mark - AirPlay notification and functionality

- (NSString *)activeAirPlayOutputRouteName
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = audioSession.currentRoute;
    for (AVAudioSessionPortDescription *outputPort in currentRoute.outputs){
        if ([outputPort.portType isEqualToString:AVAudioSessionPortAirPlay]) {
            return outputPort.portName;
        }
    }
    return nil;
}

- (void)audioRouteHasChangedNotification:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *airPlayOutputRouteName = [weakSelf activeAirPlayOutputRouteName];
        NSLog(@"%s: %@; outputRoute = %@",__func__, notification, airPlayOutputRouteName);
        if (airPlayOutputRouteName) {
            [weakSelf showAirPlayIconWithOutputName:airPlayOutputRouteName];
        } else {
            [weakSelf showAirPlayStatusView:false];
        }
        
    });
    
}

- (void)airplayAvailabilityHasChangedNotification:(NSNotification *)notification
{
    NSLog(@"%s: %@",__func__, notification);
    float animationTimeInterval = 0.5;
    if (self.airplayButton.wirelessRoutesAvailable) {
        airplayButtonFrame = kPlayerHudBottomItemFrame;
        [UIView animateWithDuration:animationTimeInterval animations:^{
            self.airplayButton.hidden = NO;
            [self resetHudBottomUILayout:self.frame];
        }];
    }else {
        airplayButtonFrame = 0;
        [UIView animateWithDuration:animationTimeInterval animations:^{
            self.airplayButton.hidden = YES;
            [self resetHudBottomUILayout:self.frame];
        }];
    }
}

- (void)showAirPlayIconWithOutputName:(NSString *)outputName
{
    airplayDeviceLabel.text = [NSString stringWithFormat:@"Playing on %@",outputName];
    [self showAirPlayStatusView:true];
}

- (void)showAirPlayStatusView:(BOOL)show
{
    if (show) {
        if (airPlayStatusView.hidden) {
            airPlayStatusView.hidden = false;
            airPlayStatusView.alpha = 1.0;
        }
    }else {
        __weak UIView *weakAirPlayStatusView = airPlayStatusView;
        if (!airPlayStatusView.hidden) {
            [UIView animateWithDuration:0.5 animations:^{
                weakAirPlayStatusView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    weakAirPlayStatusView.hidden = true;
                }
            }];
        }
    }
}


#pragma mark - Observer handling for player, playerItem

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *mPlayerItem = (AVPlayerItem *)object;
        
        //playerItem status value changed?
        if ([keyPath isEqualToString:@"status"]) {
            // if yes, determine it...
            switch(mPlayerItem.status) {
                case AVPlayerItemStatusFailed:
                    NSLog(@"%s: player item status failed", __func__);
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    NSLog(@"%s: player item status is ready to play", __func__);
                    [self showActivityIndicator:false];
                    if (!isNotFirstPlay) {
                        isNotFirstPlay = YES;
                        totalMovieDuration = CMTimeGetSeconds(mPlayerItem.duration);
                        self.playerSlider.maximumValue = totalMovieDuration;
                    }
                    break;
                case AVPlayerItemStatusUnknown:
                    NSLog(@"%s: player item status is unknown", __func__);
                    break;
            }
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            if (mPlayerItem.playbackBufferEmpty) {
                if (!mPlayerItem.isPlaybackLikelyToKeepUp && !mPlayerItem.isPlaybackBufferFull) {
                    
                    // perform secondary check that player has actually stopped
                    if (self.moviePlayer.rate == 0.0) {
                        if (!isBufferPause) {
                            isBufferPause = true;
                            [self showActivityIndicator:true];
                            [self pause];
                        }
                    }
                }
                NSLog(@"%s: player item playback buffer is empty", __func__);
            }
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            float bufferTime = [self availableDuration];
            float bufferValue = (bufferTime/totalMovieDuration);
            if (!isinf(bufferValue) && !isnan(bufferValue)) {
                self.playerSlider.middleValue = bufferValue;
            }
            if (!mPlayerItem.playbackBufferEmpty && isBufferPause) {
                isBufferPause = false;
                [self showActivityIndicator:false];
                [self play];
            }
            //        playSlider.middleValue = 1.0/bufferTime;
            //        double time = CMTimeGetSeconds(playerView.player.currentTime);
//            NSLog(@"buffer=%.2f%%",(bufferTime/totalMovieDuration)*100);
        }
    }else if ([object isKindOfClass:[AVPlayer class]]) {
        // secondary check on activityIndicator, remove shown && framerate > 0.0
        if ([keyPath isEqual:@"rate"]) {
            CGFloat frameRate = [(AVPlayer*)object rate];
            if (frameRate > 0.0 && activityIndicator) {
                [self showActivityIndicator:false];
            }
            NSLog(@"%s: player rate is %f", __func__, [(AVPlayer *)object rate]);
        }
    }
}


#pragma mark - KVO of Player notifications, setup/teardown

- (void)registerObservers
{
    // monitor playhead position if reached end
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];

    // monitor audio output (AirPlay)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteHasChangedNotification:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    // monitor AirPlay availability (via MPVolumeView)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airplayAvailabilityHasChangedNotification:) name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:self.airplayButton];
    
    // monitor playerItem status (ready to play, failed; buffer)
    for (NSString *keyPath in [self observablePlayerItemKeypaths]) {
        [self.playerItem addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    // monitor player frame rate
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)unregisterObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (NSString *keyPath in [self observablePlayerItemKeypaths]) {
        [self.playerItem removeObserver:self forKeyPath:keyPath];
    }
    [self.player removeObserver:self forKeyPath:@"rate"];
}

- (NSArray *)observablePlayerItemKeypaths
{
    return [NSArray arrayWithObjects:@"playbackBufferEmpty", @"status", @"loadedTimeRanges", nil];
}


#pragma mark - Helper Method

- (void)checkIsPlayable:(NSURL *)url completionHandler:(void (^)(BOOL isPlayable))completion
{
    
    assetForTest = [AVAsset assetWithURL:url];
    NSArray *keys = @[@"tracks", @"playable", @"duration"];
    
    __weak typeof(assetForTest) weakAsset = assetForTest;
    [assetForTest loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BOOL playable = NO;
            // check the keys
            for (NSString *key in keys) {
                NSError *error = nil;
                AVKeyValueStatus keyStatus = [weakAsset statusOfValueForKey:key error:&error];
                
                switch (keyStatus) {
                    case AVKeyValueStatusFailed:{
                        // failed
                        break;
                    }
                    case AVKeyValueStatusLoaded:{
                        // success
                        break;
                    }case AVKeyValueStatusCancelled:{
                        // cancelled
                        break;
                    }
                    default:{
                        break;
                    }
                }
            }
            
            // check playable
            playable = weakAsset.playable;
            [weakAsset cancelLoading];
            
            if (playable) {
                
                if (completion) {
                    completion(YES);
                }
                
            }else {
                
                if (completion) {
                    completion(NO);
                }
                
            }
            
        });
        
    }];
    
}


#pragma mark - No Use Method

+ (UIImage *)getTransparentImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, [UIScreen mainScreen].scale);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return transparentImage;
}

+ (UIImage *)drawButtonImage
{
    float scale = [UIScreen mainScreen].scale;
    float size = 40*scale;
    float width = 1*scale;
    //    float bottomPadding = 0;
    //    float rightLeftPadding = 1;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, scale);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(imageContext);
    CGContextSaveGState(imageContext);
    //    CGContextSetRGBStrokeColor(imageContext, 252.0/255.0, 168.0/255.0, 76.0/255.0, 255.0/255.0);
    CGContextSetRGBStrokeColor(imageContext, 1.0, 0.5, 0.0, 1.0);
    CGContextSetRGBFillColor(imageContext, 1.0, 0.5, 0.0, 1.0);
    CGContextSetLineWidth(imageContext, width);
    CGContextMoveToPoint(imageContext, 0, 0);
    CGContextAddLineToPoint(imageContext, size, 0);
    CGContextAddLineToPoint(imageContext, size, size);
    CGContextAddLineToPoint(imageContext, 0, size);
    CGContextDrawPath(imageContext, kCGPathFill);
    CGContextRestoreGState(imageContext);
    UIGraphicsPopContext();
    
    CGImageRef imgRef = CGBitmapContextCreateImage(imageContext);
    UIImage *sliderImage = [UIImage imageWithCGImage:imgRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    //    CGContextRelease(imageContext);
    return sliderImage;
}

@end
