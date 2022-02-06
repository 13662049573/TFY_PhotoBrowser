//
//  TFY_PhotoAVPlayerActionView.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "TFY_PhotoAVPlayerActionView.h"
#import <objc/runtime.h>


@interface TFY_PhotoAVPlayerActionView ()
@property (nonatomic , weak) UIImageView *pauseImgView;
@property (nonatomic , weak) UIImageView *dismissImgView;
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
    UIImageView *pauseImgView = [[UIImageView alloc] init];
    [pauseImgView setUserInteractionEnabled:true];
    [pauseImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseImageViewDidClick)]];
    if(UIScreen.mainScreen.scale < 3) {
        [pauseImgView setImage:[UIImage imageNamed:@"PhotoBrowser.bundle/playCenter@2x" inBundle:bundle compatibleWithTraitCollection:nil]];
    }else {
        [pauseImgView setImage:[UIImage imageNamed:@"PhotoBrowser.bundle/playCenter@3x" inBundle:bundle compatibleWithTraitCollection:nil]];
    }
    [self addSubview:pauseImgView];
    _pauseImgView = pauseImgView;
    
    // 2.dismiss imageView
    UIImageView *dismissImageView = [[UIImageView alloc] init];
    [dismissImageView setUserInteractionEnabled:true];
    [dismissImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageViewDidClick)]];
    if(UIScreen.mainScreen.scale < 3) {
        [dismissImageView setImage:[UIImage imageNamed:@"PhotoBrowser.bundle/dismiss@2x" inBundle:bundle compatibleWithTraitCollection:nil]];
    }else {
        [dismissImageView setImage:[UIImage imageNamed:@"PhotoBrowser.bundle/dismiss@3x" inBundle:bundle compatibleWithTraitCollection:nil]];
    }
    [dismissImageView setHidden:true];
    [self addSubview:dismissImageView];
    _dismissImgView = dismissImageView;
    
    // 3.loading imageView
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _pauseImgView.frame     = CGRectMake((self.frame.size.width - 80) * 0.5, (self.frame.size.height - 80) * 0.5, 80, 80);
    
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
    _dismissImgView.frame   = CGRectMake(x, y, 20, 20);
    _indicatorView.frame    = CGRectMake((self.frame.size.width - 30) * 0.5, (self.frame.size.height - 30) * 0.5, 30, 30);
}

- (void)pauseImageViewDidClick{
    
    if (_pauseImgView.hidden == false) {
        _pauseImgView.hidden = true;
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
    
    [_dismissImgView setHidden:!_dismissImgView.hidden];
    
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewDidClickIsHidden:)]) {
        [_delegate photoAVPlayerActionViewDidClickIsHidden:_dismissImgView.isHidden];
    }
}

/**
 avPlayerActionView need hidden or not
 */
- (void)avplayerActionViewNeedHidden:(BOOL)isHidden{
    if (isHidden == true) {
        [_dismissImgView setHidden:true];
        [_indicatorView setHidden:true];
        [_pauseImgView setHidden:true];
    }else {
        [_pauseImgView setHidden:false];
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
    [_pauseImgView setHidden:isPlaying];
}

- (void)setIsDownloading:(BOOL)isDownloading{
    _isDownloading = isDownloading;
    [_pauseImgView setHidden:isDownloading];
}


@end
