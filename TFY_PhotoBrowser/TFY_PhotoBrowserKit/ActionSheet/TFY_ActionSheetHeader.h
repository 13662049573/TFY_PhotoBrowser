//
//  TFY_ActionSheetHeader.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#ifndef TFY_ActionSheetHeader_h
#define TFY_ActionSheetHeader_h

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/SDImageCache.h>

#import "TFY_ActionSheetItem.h"
#import "TFY_ActionSheet.h"
#import "TFY_Reachability.h"
#import "TFY_PhotoProgressHUD.h"
#import "TFY_PhotoBrowserNumView.h"
#import "TFY_PhotoDownloadMgr.h"

#define PhotoWidth [UIScreen mainScreen].bounds.size.width
#define PhotoHeight [UIScreen mainScreen].bounds.size.height

#define PhotoDeviceHasBang \
({\
    BOOL hasBang = false;\
    if (@available(iOS 11.0, *)) {\
        hasBang = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;\
    }\
    (hasBang);\
})

#define PhotoisPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)


#define PhotoBrowserAnimateTime 0.3
#define PhotoBrowserPrefetchNum     8

#endif /* TFY_ActionSheetHeader_h */
