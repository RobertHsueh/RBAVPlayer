//
//  RBAVPlayerVC.m
//  RBAVPlayer
//
//  Created by RobertHsueh on 2020/8/26.
//  Copyright © 2020 Robert. All rights reserved.
//

#import "RBAVPlayerVC.h"
#import "RBAVPlayerView.h"

@interface RBAVPlayerVC () <RBAVPlayerViewDelegate>

@property (nonatomic, strong) RBAVPlayerView *playerView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImage *imagePlay;
@property (nonatomic, strong) UIImage *imagePause;
@property (nonatomic, strong) UIImage *imageFullScreen;

@end

@implementation RBAVPlayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Big Buck Bunny";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawImage];
    
    //http://content.uplynk.com/468ba4d137a44f7dab3ad028915d6276.m3u8
    NSURL *playURL = [NSURL URLWithString:@"http://content.uplynk.com/468ba4d137a44f7dab3ad028915d6276.m3u8"];
    
    NSLog(@"url = %@" ,playURL);
    [self preparePlayerWithURL:playURL];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (void)drawImage
{
    //play image
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(32.0, 32.0), NO, [UIScreen mainScreen].scale);
    
    UIColor *color = [UIColor whiteColor];
    UIBezierPath *bezierPlayPath = [UIBezierPath bezierPath];
    [bezierPlayPath moveToPoint: CGPointMake(0.0, 0.0)];
    [bezierPlayPath addLineToPoint: CGPointMake(0.0, 32.0)];
    [bezierPlayPath addLineToPoint: CGPointMake(32.0, 16.0)];
    [bezierPlayPath addLineToPoint: CGPointMake(0.0, 0.0)];
    [UIColor.whiteColor setFill];
    [bezierPlayPath fill];
    [color setStroke];
    bezierPlayPath.lineWidth = 1;
    [bezierPlayPath stroke];
    
    self.imagePlay = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //pause image
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(32.0, 32.0), NO, [UIScreen mainScreen].scale);
    
    UIBezierPath *bezierPausePath = [UIBezierPath bezierPath];
    [bezierPausePath moveToPoint: CGPointMake(10.5, 4.5)];
    [bezierPausePath addCurveToPoint: CGPointMake(10.5, 25.5) controlPoint1: CGPointMake(10.5, 24.5) controlPoint2: CGPointMake(10.5, 25.5)];
    [UIColor.whiteColor setStroke];
    bezierPausePath.lineWidth = 4;
    [bezierPausePath stroke];
    
    UIBezierPath *bezierPause2Path = [UIBezierPath bezierPath];
    [bezierPause2Path moveToPoint: CGPointMake(22.5, 4.5)];
    [bezierPause2Path addCurveToPoint: CGPointMake(22.5, 25.5) controlPoint1: CGPointMake(22.5, 24.5) controlPoint2: CGPointMake(22.5, 25.5)];
    [UIColor.whiteColor setStroke];
    bezierPause2Path.lineWidth = 4;
    [bezierPause2Path stroke];
    
    self.imagePause = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //full screen image
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(32.0, 32.0), NO, [UIScreen mainScreen].scale);
    
    UIBezierPath *bezierFullScreenPath = [UIBezierPath bezierPath];
    [bezierFullScreenPath moveToPoint: CGPointMake(0.5, -0.5)];
    [bezierFullScreenPath addCurveToPoint: CGPointMake(0.5, 14.5) controlPoint1: CGPointMake(0.5, 13.5) controlPoint2: CGPointMake(0.5, 14.5)];
    [bezierFullScreenPath addLineToPoint: CGPointMake(14.5, 0.5)];
    [bezierFullScreenPath addLineToPoint: CGPointMake(0.5, 0.5)];
    [UIColor.whiteColor setFill];
    [bezierFullScreenPath fill];
    [UIColor.whiteColor setStroke];
    bezierFullScreenPath.lineWidth = 1;
    [bezierFullScreenPath stroke];
    
    UIBezierPath *bezierFullScreen2Path = [UIBezierPath bezierPath];
    [bezierFullScreen2Path moveToPoint: CGPointMake(17.5, 31.5)];
    [bezierFullScreen2Path addLineToPoint: CGPointMake(31.5, 31.5)];
    [bezierFullScreen2Path addLineToPoint: CGPointMake(31.5, 17.5)];
    [bezierFullScreen2Path addLineToPoint: CGPointMake(17.5, 31.5)];
    [UIColor.whiteColor setFill];
    [bezierFullScreen2Path fill];
    [UIColor.whiteColor setStroke];
    bezierFullScreen2Path.lineWidth = 1;
    [bezierFullScreen2Path stroke];
    
    UIBezierPath *bezierFullScreen3Path = [UIBezierPath bezierPath];
    [bezierFullScreen3Path moveToPoint: CGPointMake(7, 8)];
    [bezierFullScreen3Path addLineToPoint: CGPointMake(13, 14)];
    [UIColor.whiteColor setStroke];
    bezierFullScreen3Path.lineWidth = 4;
    [bezierFullScreen3Path stroke];
    
    UIBezierPath *bezierFullScreen4Path = [UIBezierPath bezierPath];
    [bezierFullScreen4Path moveToPoint: CGPointMake(18, 19)];
    [bezierFullScreen4Path addLineToPoint: CGPointMake(24, 25)];
    [UIColor.whiteColor setStroke];
    bezierFullScreen4Path.lineWidth = 4;
    [bezierFullScreen4Path stroke];
    
    self.imageFullScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


#pragma mark - Orientation

//for iOS6 and later
- (BOOL)shouldAutorotate
{
    return YES;
}

//for iOS6 and later
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//for iOS6 and later
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)orientationChanged:(NSNotification *)noti
{
    UIDevice *device = noti.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            NSLog(@"Portrait");
            [self resetUILayout:UIDeviceOrientationPortrait];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            NSLog(@"LandscapeLeft");
            [self resetUILayout:UIDeviceOrientationLandscapeLeft];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start special animation */
            NSLog(@"LandscapeRight");
            [self resetUILayout:UIDeviceOrientationLandscapeRight];
            break;
            
        default:
            break;
    }
}

- (void)resetUILayout:(UIDeviceOrientation)orientation
{
//    if (orientation == UIDeviceOrientationPortrait) {
//
//    }else if (orientation == UIDeviceOrientationLandscapeLeft) {
//
//    }else if (orientation == UIDeviceOrientationLandscapeRight) {
//
//    }
    [self setupPlayerFrame];
    if (self.activityView) {
        self.activityView.center = CGPointMake(self.activityView.superview.frame.size.width/2, self.activityView.superview.frame.size.height/2);
    }
}


#pragma mark - RBAVPlayerView preparation and setup

- (void)preparePlayerWithURL:(NSURL *)url
{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    self.activityView.center = CGPointMake(self.activityView.superview.frame.size.width/2, self.activityView.superview.frame.size.height/2);
    
    __weak typeof(self) weakSelf = self;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"duration"] completionHandler:^{
        NSError *error = nil;
        switch ([asset statusOfValueForKey:@"duration" error:&error]) {
                
            case AVKeyValueStatusLoaded:{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.activityView stopAnimating];
                    [weakSelf.activityView removeFromSuperview];
                    weakSelf.activityView = nil;
                    [weakSelf setupAndStartPlaying:asset.URL];
                    
                });
                
            }break;
                
            default:{
                NSLog(@"%s: %@", __func__, [error localizedDescription]);
            }break;
        }
        
    }];
    
}

- (void)setupAndStartPlaying:(NSURL *)url
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setupPlayer:url];
        [weakSelf.playerView play];
    });
}

- (void)setupPlayer:(NSURL *)url
{
    // Create video player
    RBAVPlayerView *aPlayer;
    aPlayer = [[RBAVPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) contentURL:url];
    aPlayer.delegate = self;
    aPlayer.shouldShowHideParentNavigationBar = YES;
//    aPlayer.shouldShowPlayerHudTop = YES;
//    aPlayer.playerTitleLabel.text = @"Big Buck Bunny";
//    aPlayer.tintColor = [UIColor redColor];
    [self.view addSubview:aPlayer];
//    aPlayer.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Overwrite 'sound off,' when vibrate switch is toggled on phone
    aPlayer.shouldPlayAudioOnVibrate = YES;
    
    self.playerView = aPlayer;
    
    //set button image
    [self.playerView.playPauseButton setBackgroundImage:self.imagePause forState:UIControlStateSelected];
    [self.playerView.playPauseButton setBackgroundImage:self.imagePlay forState:UIControlStateNormal];
    [self.playerView.fullScreenButton setBackgroundImage:self.imageFullScreen forState:UIControlStateNormal];
    
    [self setupPlayerFrame];
}

- (void)setupPlayerFrame
{
    if (!self.playerView.superview) {
        return;
    }
    self.playerView.frame = self.playerView.superview.frame;
    CGFloat width = self.playerView.frame.size.width;
    CGFloat height = self.playerView.frame.size.height;
    double scale = width/height;
    CGRect frameFix = self.playerView.frame;
    if (width < height) {
        frameFix.size.height = width*9.0/16.0;
    }else if (width >= height) {
        frameFix.size.width = height*scale;
    }
    self.playerView.frame = frameFix;
    self.playerView.center = self.playerView.superview.center;
}


#pragma mark - RBAVPlayerView Delegate

- (void)RBAVPlayerViewWillPlay:(RBAVPlayerView *)view
{
    NSLog(@"RBAVPlayerViewWillPlay");
}

- (void)RBAVPlayerViewDidPlay:(RBAVPlayerView *)view
{
    NSLog(@"RBAVPlayerViewDidPlay");
}

- (void)RBAVPlayerViewWillPause:(RBAVPlayerView *)view
{
    NSLog(@"RBAVPlayerViewWillPause");
}

- (void)RBAVPlayerViewDidPause:(RBAVPlayerView *)view
{
    NSLog(@"RBAVPlayerViewDidPause");
}

- (void)RBAVPlayerViewFinishedPlayback:(RBAVPlayerView *)view
{
    NSLog(@"RBAVPlayerViewFinishedPlayback");
}

@end
