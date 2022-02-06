//
//  TFY_PhotoItems.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoDownloadState) {
    PhotoDownloadStateUnknow,
    PhotoDownloadStateDownloading,
    PhotoDownloadStateSuccess,
    PhotoDownloadStateFailure,
    PhotoDownloadStateRepeat,
    PhotoDownloadStateSaveFailure,
    PhotoDownloadStateSaveSuccess
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoItems : NSObject

/// 如果是network image或(net or locate video)，设置photoUrl，不要设置sourceImage
@property (nonatomic,copy  ) NSString *photoUrl;

/// 如果是locate image，设置sourceImage，不要设置url
@property (nonatomic,strong) UIImage *sourceImage;

///是否定位GIF图像，默认为false。
///如果是定位GIF图像，设置为true。
///如果是网络GIF图片或视频，不要设置它
@property (nonatomic,assign) BOOL isLocateGif;

/// sourceView是当前显示图像或视频的控件。
/// 1。如果sourceView是' UIImageView '或' UIButton '只要只设置sourceView。
/// 2。如果sourceView是自定义视图，设置' sourceView '，但不要忘记设置' sourceLinkArr ' && ' sourceLinkProperyName '。
@property (nonatomic,strong) UIView *sourceView;

/// sourceView的子视图类(如果设置sourceLinkArr，那么必须设置sourceLinkProperyName时，它不是' UIImageView '或' UIButton ')
@property (nonatomic,strong) NSArray<NSString *> *sourceLinkArr;
/**
 eg:
 如果lastObject是UIImageView, sourceLinkProperyName是image
 如果lastObject是UIButton sourceLinkProperyName是currentBackgroundImage或currentImage
 */
@property (nonatomic,copy  ) NSString *sourceLinkProperyName;
/// 是否video，默认为false
@property (nonatomic,assign) BOOL isVideo;

/// 当' isVideo '为true，并且视频是网络类型，尝试设置videoimageurl，它就像网络视频的image
@property (nonatomic,copy  ) NSString *videoPlaceHolderImageUrl;

/// 视频正在下载或其他状态，默认为未知
@property (nonatomic,assign) PhotoDownloadState downloadState;

/// 视频正在下载，当前进度
@property (nonatomic,assign) float downloadProgress;

@end

@interface UIDevice(Extension)
/// 设备裁判确实有专辑的认证
+ (void)deviceAlbumAuth:(void (^)(BOOL isAuthor))authorBlock;

+ (void)deviceShake;

@end


NS_ASSUME_NONNULL_END
