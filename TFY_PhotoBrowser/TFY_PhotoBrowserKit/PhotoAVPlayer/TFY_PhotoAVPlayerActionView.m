//
//  TFY_PhotoAVPlayerActionView.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "TFY_PhotoAVPlayerActionView.h"
#import <objc/runtime.h>


@interface TFY_PhotoAVPlayerActionView ()
@property (nonatomic , weak) UIButton *pausebtn;
@property (nonatomic , weak) UIButton *dismissbtn;
@property (nonatomic , strong) UIActivityIndicatorView *indicatorView;
@end

@implementation TFY_PhotoAVPlayerActionView

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView setHidesWhenStopped:true];
    }
    return _indicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:UIColor.clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionViewDidClick)]];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"PhotoBrowser")];
    
    // 1.stop || play imageView
    UIButton *pausebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pausebtn.userInteractionEnabled = YES;
    [pausebtn addTarget:self action:@selector(pauseImageViewDidClick) forControlEvents:UIControlEventTouchUpInside];
    if(UIScreen.mainScreen.scale < 3) {
        UIImage *image = [UIImage imageNamed:@"PhotoBrowser.bundle/playCenter@2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [pausebtn setImage:image forState:UIControlStateNormal];
    }else {
        UIImage *image = [UIImage imageNamed:@"PhotoBrowser.bundle/playCenter@3x" inBundle:bundle compatibleWithTraitCollection:nil];
        [pausebtn setImage:image forState:UIControlStateNormal];
    }
    [self addSubview:pausebtn];
    _pausebtn = pausebtn;
    
    // 2.dismiss imageView
    UIButton *dismissbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissbtn.userInteractionEnabled = YES;
    [dismissbtn addTarget:self action:@selector(dismissImageViewDidClick) forControlEvents:UIControlEventTouchUpInside];
    if(UIScreen.mainScreen.scale < 3) {
        UIImage *image = [UIImage imageNamed:@"PhotoBrowser.bundle/dismiss@2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [dismissbtn setImage:image forState:UIControlStateNormal];
    }else {
        UIImage *image = [UIImage imageNamed:@"PhotoBrowser.bundle/dismiss@3x" inBundle:bundle compatibleWithTraitCollection:nil];
        [dismissbtn setImage:image forState:UIControlStateNormal];
    }
    dismissbtn.hidden = YES;
    [self addSubview:dismissbtn];
    _dismissbtn = dismissbtn;
    
    // 3.loading imageView
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _pausebtn.frame     = CGRectMake((self.frame.size.width - 80) * 0.5, (self.frame.size.height - 80) * 0.5, 80, 80);
    
    CGFloat y = 25;
    CGFloat x = 10;
    if(PhotoDeviceHasBang){
        y = 45;
        x = 20;
    }
    
    if(!PhotoisPortrait){
        y = 15;
        x = 35;
    }
    _dismissbtn.frame   = CGRectMake(x, y, 34, 34);
    _indicatorView.frame    = CGRectMake((self.frame.size.width - 30) * 0.5, (self.frame.size.height - 30) * 0.5, 30, 30);
}

- (void)pauseImageViewDidClick{
    if (_pausebtn.hidden == false) {
        _pausebtn.hidden = true;
    }
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewPauseOrStop)]) {
        [_delegate photoAVPlayerActionViewPauseOrStop];
    }
}

- (void)dismissImageViewDidClick{
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewDismiss)]) {
        [_delegate photoAVPlayerActionViewDismiss];
    }
}

- (void)actionViewDidClick{
    [_dismissbtn setHidden:!_dismissbtn.hidden];
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewDidClickIsHidden:)]) {
        [_delegate photoAVPlayerActionViewDidClickIsHidden:_dismissbtn.isHidden];
    }
}

/**
 avPlayerActionView need hidden or not
 */
- (void)avplayerActionViewNeedHidden:(BOOL)isHidden{
    if (isHidden == true) {
        [_dismissbtn setHidden:true];
        [_indicatorView setHidden:true];
        [_pausebtn setHidden:true];
    }else {
        [_pausebtn setHidden:false];
    }
}

- (void)setIsBuffering:(BOOL)isBuffering{
    _isBuffering = isBuffering;
    if (isBuffering) {
        [_indicatorView startAnimating];
    }else{
        [_indicatorView stopAnimating];
    }
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    [_pausebtn setHidden:isPlaying];
}

- (void)setIsDownloading:(BOOL)isDownloading{
    _isDownloading = isDownloading;
    [_pausebtn setHidden:isDownloading];
}


@end
