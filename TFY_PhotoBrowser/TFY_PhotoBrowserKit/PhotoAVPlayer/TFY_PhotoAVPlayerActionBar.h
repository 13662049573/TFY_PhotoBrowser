//
//  TFY_PhotoAVPlayerActionBar.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>

@protocol PhotoAVPlayerActionBarDelegate <NSObject>
@optional
/**
 actionBar暂停或停止btn点击
 */
- (void)photoAVPlayerActionBarClickWithIsPlay:(BOOL)isNeedPlay;
/**
 actionBar的值已经被滑块改变
 */
- (void)photoAVPlayerActionBarChangeValue:(float)value;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoAVPlayerActionBar : UIView
/**
 视频的当前播放时间
 */
@property (nonatomic , assign) float  currentTime;
/**
 视频时长
 */
@property (nonatomic , assign) float  allDuration;

@property (nonatomic , weak) id<PhotoAVPlayerActionBarDelegate> delegate;
/**
 是否开启播放
 */
@property (nonatomic , assign) BOOL isPlaying;
/**
 重置ActionBar的所有信息
 */
- (void)resetActionBarAllInfo;

@end

NS_ASSUME_NONNULL_END
