//
//  TFY_PhotoVideoCell.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import "TFY_PhotoAVPlayerHeader.h"
#import "TFY_ActionSheetHeader.h"

@protocol PhotoVideoCellDelegate <NSObject>

- (void)photoVideoAVPlayerDismiss;

- (void)photoVideoAVPlayerLongPress:(UILongPressGestureRecognizer *_Nonnull)longPress;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoVideoCell : UICollectionViewCell
/// 使用photoItems和placeHolder的图像在线播放视频
- (void)playerOnLinePhotoItems:(TFY_PhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder;

/// 播放视频下载首先与photoItems和占位符的图像
- (void)playerLocatePhotoItems:(TFY_PhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder;

- (void)playerWillEndDisplay;

@property (nonatomic,assign) BOOL isNeedAutoPlay;
@property (nonatomic,assign) BOOL isNeedVideoPlaceHolder;
@property (nonatomic,assign) BOOL isSoloAmbient;

@property (nonatomic,weak  ) TFY_PhotoAVPlayerView *onlinePlayerView;
@property (nonatomic,weak  ) TFY_PhotoLocateAVPlayerView *locatePlayerView;
@property (nonatomic,weak  ) TFY_PhotoProgressHUD *progressHUD;

@property (nonatomic,weak  ) id<PhotoVideoCellDelegate> delegate;

@property (nonatomic,assign) UIViewContentMode presentedMode;

@end

NS_ASSUME_NONNULL_END
