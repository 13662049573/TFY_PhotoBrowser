//
//  TFY_PhotoAVPlayerView.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TFY_ActionSheetHeader.h"
#import "TFY_PhotoAVPlayerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoAVPlayerView : UIView

/// 创建定位播放器与photoItems
- (void)playerOnLinePhotoItems:(TFY_PhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder;
/// reset AVPlayer
- (void)playerWillReset;
/// AVPlayer 会用手刷卡吗
- (void)playerWillSwipe;
/// AVPlayer 将取消刷卡
- (void)playerWillSwipeCancel;
/// AVPlayer扮演率
- (void)playerRate:(CGFloat)rate;
/**
 * 是否需要视频占位符
 */
@property (nonatomic,assign) BOOL isNeedVideoPlaceHolder;

/**
 * 需要时自动播放
 */
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/**
 * 的观点
 */
@property (nonatomic,strong,nullable) UIView *playerView;

/**
 * 背景视图(如滑动定位当前位置)
 */
@property (nonatomic,strong,nullable) UIView *playerBgView;

/**
 * 占位符imageView
 */
@property (nonatomic,strong,nullable) UIImageView *placeHolderImgView;

/**
 *层
 */
@property (nonatomic,strong,nullable) AVPlayerLayer *playerLayer;

/**
 * 如果视频已经播放，即使只有一秒:TRUE
 */
@property (nonatomic,assign) BOOL isBeginPlayed;

/**
 *默认是solo ambient: TRUE ' AVAudioSessionCategorySoloAmbient '如果设置为false，它将是' AVAudioSessionCategoryAmbient '
 */
@property (nonatomic, assign) BOOL isSoloAmbient;

/**
 * delegate
 */
@property (nonatomic , weak) id<PhotoPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
