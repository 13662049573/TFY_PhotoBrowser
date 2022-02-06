//
//  TFY_PhotoDownloadMgr.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <Foundation/Foundation.h>
#import "TFY_PhotoItems.h"

typedef void(^PhotoDownLoadBlock)(PhotoDownloadState downloadState, float progress);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoDownloadMgr : NSObject<NSURLSessionDelegate>
/// single
+ (instancetype)shareInstance;

/// default file path
/// [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"TFY_PhotoBrowserData"];
@property (nonatomic,copy, readonly) NSString *filePath;

- (void)downloadVideoWithPhotoItems:(TFY_PhotoItems *)photoItems
                      downloadBlock:(PhotoDownLoadBlock)downloadBlock;

/// cancel all download task
- (void)cancelTask;

@end

@interface TFY_PhotoDownloadFileMgr : NSObject

/// default file path
/// [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"TFY_PhotoBrowserData"];
@property (nonatomic,copy, readonly) NSString *filePath;

/// 检出filePath是否包含当前视频
- (BOOL)startCheckIsExistVideo:(TFY_PhotoItems *)photoItems;

/// 获取当前视频的filePath (filePath类似于:“123”到MD5加密，并添加“。mp4”)
- (NSString *)startGetFilePath:(TFY_PhotoItems *)photoItems;

/// 通过photoItems删除视频
- (void)removeVideoByPhotoItems:(TFY_PhotoItems *)photoItems;

/// 删除
- (void)removeVideoByURLString:(NSString *)urlString;

/// 删除全部
- (void)removeAllVideo;

@end

NS_ASSUME_NONNULL_END
