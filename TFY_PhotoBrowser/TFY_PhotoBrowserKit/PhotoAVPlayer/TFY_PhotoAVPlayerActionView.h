//
//  TFY_PhotoAVPlayerActionView.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import "TFY_ActionSheetHeader.h"

@protocol PhotoAVPlayerActionViewDelegate <NSObject>
@optional
/**
 actionView的暂停imageView
 */
- (void)photoAVPlayerActionViewPauseOrStop;
/**
 actionView的驳回imageView
 */
- (void)photoAVPlayerActionViewDismiss;
/**
 actionView
 */
- (void)photoAVPlayerActionViewDidClickIsHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoAVPlayerActionView : UIView
/**
 avPlayerActionView是否需要隐藏
 */
- (void)avplayerActionViewNeedHidden:(BOOL)isHidden;

@property (nonatomic , weak) id<PhotoAVPlayerActionViewDelegate> delegate;
/**
 是否在缓冲
 */
@property (nonatomic , assign) BOOL  isBuffering;
/**
 当前是否播放
 */
@property (nonatomic , assign) BOOL  isPlaying;
/**
 * 当前播放器正在下载
 */
@property (nonatomic , assign) BOOL isDownloading;

@end

NS_ASSUME_NONNULL_END
