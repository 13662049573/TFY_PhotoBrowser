//
//  TFY_PhotoLocateAVPlayerView.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "TFY_PhotoLocateAVPlayerView.h"

@interface TFY_PhotoLocateAVPlayerView ()<PhotoAVPlayerActionViewDelegate,PhotoAVPlayerActionBarDelegate>

@property (nonatomic,strong) AVPlayer       *player;
@property (nonatomic,strong) AVPlayerItem   *item;

@property (nonatomic,strong) TFY_PhotoAVPlayerActionView *actionView;
@property (nonatomic,strong) TFY_PhotoAVPlayerActionBar  *actionBar;

@property (nonatomic,copy  ) NSString *photoUrl;
@property (nonatomic,strong) UIImage *placeHolder;
@property (nonatomic,strong) NSData *photoData;

@property (nonatomic,strong) id timeObserver;

@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isGetAllPlayItem;
@property (nonatomic,assign) BOOL isDragging;
@property (nonatomic,assign) BOOL isEnterBackground;
@property (nonatomic,assign) BOOL isAddObserver;

@property (nonatomic,strong) TFY_PhotoDownloadMgr *downloadMgr;
@property (nonatomic,strong) TFY_PhotoItems *photoItems;
@property (nonatomic,weak  ) TFY_PhotoProgressHUD *progressHUD;
@property (nonatomic,copy  ) PhotoDownLoadBlock downloadBlock;

@end

@implementation TFY_PhotoLocateAVPlayerView

- (TFY_PhotoAVPlayerActionView *)actionView{
    if (!_actionView) {
        _actionView = [[TFY_PhotoAVPlayerActionView alloc] init];
        [_actionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoAVPlayerActionViewDidLongPress:)]];
        _actionView.delegate = self;
        _actionView.isBuffering = false;
        _actionView.isPlaying = false;
    }
    return _actionView;
}
- (TFY_PhotoAVPlayerActionBar *)actionBar{
    if (!_actionBar) {
        _actionBar = [[TFY_PhotoAVPlayerActionBar alloc] init];
        _actionBar.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.];
        _actionBar.delegate = self;
        _actionBar.isPlaying = false;
        _actionBar.hidden = true;
    }
    return _actionBar;
}

- (UIView *)playerBgView{
    if (!_playerBgView) {
        _playerBgView = [[UIView alloc] init];
    }
    return _playerBgView;
}
- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = UIColor.clearColor;
    }
    return _playerView;
}
- (UIImageView *)placeHolderImgView{
    if (!_placeHolderImgView) {
        _placeHolderImgView = [[UIImageView alloc] init];
        _placeHolderImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _placeHolderImgView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.player = [AVPlayer playerWithPlayerItem:_item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [self.playerView.layer addSublayer:_playerLayer];
        
        [self.playerBgView addSubview:self.placeHolderImgView];
        [self.playerBgView addSubview:self.playerView];
        
        [self addSubview:self.playerBgView];
        [self addSubview:self.actionView];
        [self addSubview:self.actionBar];
        
        _downloadBlock = nil;
    }
    return self;
}

- (void)playerLocatePhotoItems:(TFY_PhotoItems *)photoItems progressHUD:(TFY_PhotoProgressHUD *)progressHUD placeHolder:(UIImage *_Nullable)placeHolder{
    
    [self cancelDownloadMgrTask];
    
    [self removePlayerItemObserver];
    [self removeTimeObserver];
    [self addObserverAndAudioSession];
    
    _downloadBlock = nil;
    
    _photoUrl = photoItems.photoUrl;
    _placeHolder = placeHolder;
    _progressHUD = progressHUD;
    _photoItems  = photoItems;
    
    _downloadMgr = [[TFY_PhotoDownloadMgr alloc] init];
    
    if (placeHolder) {
        _placeHolderImgView.image = placeHolder;
    }
    
    _item = nil;
    
    if ([photoItems.photoUrl hasPrefix:@"http"] || [photoItems.photoUrl hasPrefix:@"https"]) {
        
        TFY_PhotoDownloadFileMgr *fileMgr = [[TFY_PhotoDownloadFileMgr alloc] init];
        if ([fileMgr startCheckIsExistVideo:photoItems]) {
            progressHUD.hidden = true;
            _actionView.isBuffering = true;
            
            NSString *filePath = [fileMgr startGetFilePath:photoItems];
            _item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil]];
        }
    } else {
        if (photoItems.photoUrl != nil) {
            progressHUD.hidden = true;
            _actionView.isBuffering = true;
            _item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_photoUrl] options:nil]];
        }
    }
    
    _item.canUseNetworkResourcesForLiveStreamingWhilePaused = true;
    [self.player replaceCurrentItemWithPlayerItem:_item];
    
    [_actionView avplayerActionViewNeedHidden:false];
    
    _isEnterBackground = _isAddObserver = _isDragging = _isPlaying = false;
    
    if (_item != nil) [self addPlayerItemObserver];
    
    /// default rate
    _player.rate = 1.0;
    
    [_player pause];
}

- (void)addObserverAndAudioSession{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:true error:nil];
    if(_isSoloAmbient == true) {
//        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    }else {
        [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    }
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

/// notification function
- (void)applicationWillResignActive{
    _isEnterBackground = true;
    if (_isPlaying) [self photoAVPlayerActionBarClickWithIsPlay:false];
}

/// remove item observer
- (void)removePlayerItemObserver{
    if (_item && _isAddObserver) {
        [_item removeObserver:self forKeyPath:@"status" context:nil];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        _isAddObserver = false;
    }
}
/// add item observer
- (void)addPlayerItemObserver{
    if (_item) {
        [_item addObserver:self forKeyPath:@"status"           options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        _isAddObserver = true;
    }
    
    __weak typeof(self) weakself = self;
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakself.isBeginPlayed = true;
        __strong typeof(weakself) strongself = weakself;
        if (CMTimeGetSeconds(time) == strongself.actionBar.allDuration) {
            if (strongself.actionBar.allDuration != 0) {
                [strongself videoDidPlayToEndTime];
            }
            strongself.actionBar.currentTime = 0;
        }else{
            if (strongself.isDragging == true) {
                strongself.isDragging = false;
                return;
            }
            strongself.actionBar.currentTime = CMTimeGetSeconds(time);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidPlayToEndTime)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
}
/// remove time observer
- (void)removeTimeObserver{
    if (_timeObserver && _player) {
        @try {
            [_player removeTimeObserver: _timeObserver];
        } @catch (NSException *exception) {
            
        } @finally {
            _timeObserver = nil;
        }
    }
}

- (void)videoDidPlayToEndTime{
    _isGetAllPlayItem = false;
    _isPlaying = false;
    if (_player) {
        __weak typeof(self) weakself = self;
         if (_player.currentItem.status == AVPlayerStatusReadyToPlay) {
            [_player seekToTime:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
                if (finished) {
                    weakself.actionBar.currentTime = 0;
                    weakself.actionBar.isPlaying = false;
                    weakself.actionView.isPlaying = false;
                }
            }];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object != self.item) return;
    
    if (_isEnterBackground) return;
    
    if ([keyPath isEqualToString:@"status"]) { // play
        if (_player.currentItem.status == AVPlayerStatusReadyToPlay) {
            _placeHolderImgView.hidden = true;
        }
        _actionView.isBuffering = false;
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // buffering
        if (!_isGetAllPlayItem) {
            _isGetAllPlayItem = true;
            _actionBar.allDuration = CMTimeGetSeconds(_player.currentItem.duration);
        }
        _actionView.isBuffering = false;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/// function
- (void)playerWillReset{
    [_player pause];
    _isPlaying = false;
    [self removeTimeObserver];
    [self removePlayerItemObserver];
}
- (void)playerWillSwipe{
    [_actionView avplayerActionViewNeedHidden:true];
    _actionBar.hidden = true;
    _progressHUD.hidden = true;
}
/// AVPlayer will cancel swipe
- (void)playerWillSwipeCancel{
    TFY_PhotoDownloadFileMgr *fileMgr = [[TFY_PhotoDownloadFileMgr alloc] init];
    if ([self.photoItems.photoUrl hasPrefix:@"http"] || [self.photoItems.photoUrl hasPrefix:@"https"]) {
        if ([fileMgr startCheckIsExistVideo:self.photoItems] == false && _progressHUD.progress != 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PhotoBrowserAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_progressHUD.hidden = false;
            });
        }else {
            _progressHUD.hidden = true;
        }
    }else {
        _progressHUD.hidden = true;
    }
}
- (void)playerRate:(CGFloat)rate{
    if (_isPlaying == false) {
        return;
    }
    _player.rate = rate;
}
/// when dismiss, should cancel download task first
- (void)cancelDownloadMgrTask{
    if (_downloadMgr) [_downloadMgr cancelTask];
}
/// playerdownload
/// @param downloadBlock download callBack
- (void)playerDownloadBlock:(PhotoDownLoadBlock)downloadBlock{
    _downloadBlock = downloadBlock;
}

/// setter
- (void)setIsNeedAutoPlay:(BOOL)isNeedAutoPlay {
    _isNeedAutoPlay = isNeedAutoPlay;
    if (isNeedAutoPlay) {
        [self photoAVPlayerActionViewPauseOrStop];
    }
}
- (void)setIsNeedVideoPlaceHolder:(BOOL)isNeedVideoPlaceHolder{
    _isNeedVideoPlaceHolder = isNeedVideoPlaceHolder;
    self.placeHolderImgView.hidden = !isNeedVideoPlaceHolder;
}

- (void)photoAVPlayerActionViewDidLongPress:(UILongPressGestureRecognizer *)longPress{
    if (_isPlaying == false) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(photoPlayerLongPress:)]) {
        [_delegate photoPlayerLongPress:longPress];
    }
}

/// delegate
/**
 actionView's Pause imageView
 */
- (void)photoAVPlayerActionViewPauseOrStop{
    TFY_PhotoDownloadFileMgr *fileMgr = [[TFY_PhotoDownloadFileMgr alloc] init];
    if (([_photoItems.photoUrl hasPrefix:@"http"] == true || [self.photoItems.photoUrl hasPrefix:@"https"] == true)&& [fileMgr startCheckIsExistVideo:_photoItems] == false) {
        if (![[TFY_Reachability reachabilityForInternetConnection] isReachable]) { // no network
            [_progressHUD setHidden:true];
            return;
        }
        _actionView.isDownloading = true;
        [_progressHUD setHidden:false];
        [_progressHUD setProgress:0.0];
        __weak typeof(self) weakself = self;
        [_downloadMgr downloadVideoWithPhotoItems:_photoItems downloadBlock:^(PhotoDownloadState downloadState, float progress) {
            [weakself.progressHUD setProgress:progress];
            if (downloadState == PhotoDownloadStateSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TFY_PhotoDownloadFileMgr *manager = [[TFY_PhotoDownloadFileMgr alloc] init];
                    NSString *filePath = [manager startGetFilePath:weakself.photoItems];
                    weakself.item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil]];
                    weakself.item.canUseNetworkResourcesForLiveStreamingWhilePaused = true;
                    [weakself.player replaceCurrentItemWithPlayerItem:weakself.item];
                    [weakself.player play];
                    weakself.player.muted = true;
                    
                    weakself.progressHUD.progress = 1.0;
                    
                    weakself.isPlaying = true;
                    weakself.actionBar.isPlaying = true;
                    weakself.actionView.isBuffering = true;
                    weakself.actionView.isPlaying = true;
                    [weakself addPlayerItemObserver];
                });
            }
            if (downloadState == PhotoDownloadStateUnknow || downloadState == PhotoDownloadStateFailure) {
                [weakself.progressHUD setProgress:0.0];
            }
            if (weakself.downloadBlock) {
                weakself.downloadBlock(downloadState, progress);
            }
        }];
    } else {
        _progressHUD.hidden = true;
        if (_isPlaying == false) {
            [_player play];
            _player.muted = true;
            _actionBar.isPlaying = true;
            _actionView.isPlaying = true;
        }else {
            [_player pause];
            _actionView.isPlaying = false;
            _actionBar.isPlaying = false;
        }
        
        _isPlaying = !_isPlaying;
    }
    _isEnterBackground = false;
}

- (void)photoAVPlayerActionViewDismiss{
    [self cancelDownloadMgrTask];
    if ([_delegate respondsToSelector:@selector(photoPlayerViewDismiss)]) {
        [_delegate photoPlayerViewDismiss];
    }
}

- (void)photoAVPlayerActionViewDidClickIsHidden:(BOOL)isHidden{
    [_actionBar setHidden:isHidden];
}

- (void)photoAVPlayerActionBarClickWithIsPlay:(BOOL)isNeedPlay{
    if (isNeedPlay) {
        [_player play];
        _player.muted = true;
        _actionView.isPlaying = true;
        _actionBar.isPlaying = true;
        _isPlaying = true;
    }else {
        [_player pause];
        _actionView.isPlaying = false;
        _actionBar.isPlaying = false;
        _isPlaying = false;
    }
}

- (void)photoAVPlayerActionBarChangeValue:(float)value{
    _isDragging = true;
    [_player seekToTime:CMTimeMake(value, 1) completionHandler:^(BOOL finished) {}];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.playerBgView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
    self.playerView.frame   = self.playerBgView.bounds;
    self.playerLayer.frame  = self.playerView.bounds;
    self.actionView.frame   = self.playerBgView.frame;
    self.placeHolderImgView.frame  = self.playerBgView.bounds;
    
    if (PhotoDeviceHasBang) {
        self.actionBar.frame    = CGRectMake(15, self.frame.size.height - 70, self.frame.size.width - 30, 40);
    }else {
        self.actionBar.frame    = CGRectMake(15, self.frame.size.height - 50, self.frame.size.width - 30, 40);
    }
}

- (void)dealloc{
    [self removeObserverAndAudioSesstion];
    if (_player && self.timeObserver) {
        [_player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void)removeObserverAndAudioSesstion{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AVAudioSession sharedInstance] setActive:false withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}


@end
