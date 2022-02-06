//
//  TFY_PhotoBrowser.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import "TFY_PhotoAVPlayerHeader.h"

@class TFY_PhotoBrowser;

@protocol PhotoBrowserDelegate <NSObject>
@optional

/// photoBrowser会随currentIndex一起解散
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser willDismissWithIndex:(NSInteger)index;

/// photoBrowser右顶按钮用currentIndex点击(你可以自定义你的右按钮，但如果你自定义你的右按钮，你需要实现你的目标动作)
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index;

/// photoBrowser图像长按(图像或gif)与currentIndex
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser imageLongPressWithIndex:(NSInteger)index;

/// photoBrowser删除图像或视频源与相对索引
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser removeSourceWithRelativeIndex:(NSInteger)relativeIndex;

/// photoBrowser删除图像或视频源绝对索引
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser removeSourceWithAbsoluteIndex:(NSInteger)absoluteIndex;

/// photoBrowser滚动到当前索引
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser scrollToLocateWithIndex:(NSInteger)index;

/// photoBrowser做长按手势识别器和索引
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser videoLongPress:(UILongPressGestureRecognizer *_Nonnull)longPress index:(NSInteger)index;

/// 下载图像或视频成功或失败或失败原因回拨。[如果视频播放器是自动下载的，可以使用委托。只有使用函数removeImageOrVideoOnPhotoBrowser才能使用这个委托]
- (void)photoBrowser:(TFY_PhotoBrowser *_Nonnull)photoBrowser
               state:(PhotoDownloadState)state
            progress:(float)progress
   photoItemRelative:(TFY_PhotoItems *_Nonnull)photoItemRe
   photoItemAbsolute:(TFY_PhotoItems *_Nonnull)photoItemAb;

/// photoBrowser将布局子视图
- (void)photoBrowserWillLayoutSubviews;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoBrowser : UIViewController
/// 目前指数
@property (nonatomic,assign) NSInteger currentIndex;

/// itemsArr包含TFY_PhotoItems: url | sourceView.....
@property (nonatomic,strong) NSArray<TFY_PhotoItems *> *itemsArr;

/// delegate
@property (nonatomic,weak  ) id<PhotoBrowserDelegate> delegate;

/// control animation mode，默认为UIViewContentModeScaleToFill
@property (nonatomic,assign) UIViewContentMode animatedMode;

/// image' control presenting mode，默认为' UIViewContentModeScaleAspectFit '
@property (nonatomic,assign) UIViewContentMode presentedMode;

/// 当源图像和图像和视频没有准备好，创建一个图像与颜色持有人，默认是UIColor.clear
@property (nonatomic,strong) UIColor *placeHolderColor;

/// 是否需要pageNumView，默认是false
@property (nonatomic,assign) BOOL isNeedPageNumView;

/// 是否需要pageControl，默认为false(但如果photobrowser包含视频，则隐藏)
@property (nonatomic,assign) BOOL isNeedPageControl;

/// 是否需要rightttopbtn，默认是false
@property (nonatomic,assign) BOOL isNeedRightTopBtn;

///是或不需要图像或视频longPress，默认为false。
/// image long press: delegate function ' photoBrowser: imageLongPressWithIndex: '。
///视频长按:委托函数' photoBrowser: videoLongPress: index: '。
@property (nonatomic,assign) BOOL isNeedLongPress;

/// 是否需要预取图像，maxCount为8
@property (nonatomic,assign) BOOL isNeedPrefetch;

/// 是否需要平移手势，默认为false
@property (nonatomic,assign) BOOL isNeedPanGesture;

/// 是否需要自动播放视频，默认为false
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/// 是否需要在线播放视频，默认为false[即先自动下载视频]
@property (nonatomic,assign) BOOL isNeedOnlinePlay;

/// is or not solo ambient, default is true `AVAudioSessionCategorySoloAmbient`. If set false ,that will be `AVAudioSessionCategoryAmbient`
@property (nonatomic,assign) BOOL isSoloAmbient;

/// ' numView ' & ' pageControl ' & ' operationBtn '是否需要跟随photoBrowser，默认为false。
///当触摸photoBrowser时，它们将被隐藏。
///当你取消，他们将显示。
///当立即关闭photoBrowser时，它们将立即被隐藏。
@property (nonatomic,assign) BOOL isNeedFollowAnimated;

/// 删除当前图像或视频的照片浏览器
- (void)removeImageOrVideoOnPhotoBrowser;

/// 下载照片或视频到相册，但必须先经过认证
- (void)downloadImageOrVideoToAlbum;

/// 速率立即使用，默认为1.0，范围为[0.5 <=速率<= 2.0]
- (void)setImmediatelyPlayerRate:(CGFloat)rate;

/**
 你可以使用下一个函数，使用' - (void)createOverlayViewArrOnTopView: animated: followAnimated: '
*/
- (void)createCustomViewArrOnTopView:(NSArray<UIView *> *)customViewArr
                            animated:(BOOL)animated
                      followAnimated:(BOOL)followAnimated;

/**
 在topView上创建覆盖视图(photoBrowser控制器的视图)
 例如:在photoBrowser控制器的视图上创建一个scrollView，当photoBrowser已经滚动时，你可以使用delegate的函数来做你想做的事情
 委托的功能:photoBrowser: scrollToLocateWithIndex: (NSInteger)指数”
 在Demo中的'CustomViewController'，你可以看到如何使用它
*/
- (void)createOverlayViewArrOnTopView:(NSArray<UIView *> *)overlayViewArr
                             animated:(BOOL)animated
                       followAnimated:(BOOL)followAnimated;

///将显示photoBrowser。
///如果' which is already presenting '，使用' - (void)present:(UIViewController *)controller '来代替
- (void)present;

 /*
  顺便说一下，你也可以按照自己的意愿呈现，比如:
 [controller presentViewController:photoBrowser animated:false completion:^{}];
  */
- (void)presentOn:(UIViewController *)controller;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
