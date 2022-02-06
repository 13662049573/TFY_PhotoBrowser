//
//  TFY_PhotoLocateAVPlayerView.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TFY_PhotoAVPlayerView.h"
#import "TFY_PhotoBrowserImageView.h"

@class TFY_PhotoProgressHUD;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoLocateAVPlayerView : UIView

/// 创建定位播放器与photoItems
- (void)playerLocatePhotoItems:(TFY_PhotoItems *)photoItems progressHUD:(TFY_PhotoProgressHUD *)progressHUD placeHolder:(UIImage *_Nullable)placeHolder;

/// 重置 AVPlayer
- (void)playerWillReset;

/// AVPlayer 会用手刷卡吗
- (void)playerWillSwipe;

/// AVPlayer 将取消刷卡
- (void)playerWillSwipeCancel;

/// AVPlayer 扮演率
- (void)playerRate:(CGFloat)rate;

/// 解散时，应先取消下载任务
- (void)cancelDownloadMgrTask;

/// playerdownload
- (void)playerDownloadBlock:(PhotoDownLoadBlock)downloadBlock;

/**
 * 是否需要视频占位符
 */
@property (nonatomic,assign) BOOL isNeedVideoPlaceHolder;

/**
 * 需要时自动播放
 */
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/**
 * player view
 */
@property (nonatomic,strong,nullable) UIView *playerView;

/**
 * 背景视图(如滑动定位当前位置)
 */
@property (nonatomic,strong,nullable) UIView *playerBgView;

/**
 * placeHolder imageView
 */
@property (nonatomic,strong,nullable) UIImageView *placeHolderImgView;

/**
 * layer of player
 */
@property (nonatomic,strong,nullable) AVPlayerLayer *playerLayer;

/**
 * 如果视频已经播放，即使只有一秒:TRUE
 */
@property (nonatomic,assign) BOOL isBeginPlayed;

/**
 * 默认是solo ambient: TRUE ' AVAudioSessionCategorySoloAmbient '
 如果设置为false，它将是' AVAudioSessionCategoryAmbient '
 */
@property (nonatomic, assign) BOOL isSoloAmbient;

/**
 * delegate
 */
@property (nonatomic,weak  ) id<PhotoPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
