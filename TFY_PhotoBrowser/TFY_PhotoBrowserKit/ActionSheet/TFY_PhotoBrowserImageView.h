//
//  TFY_PhotoBrowserImageView.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import "TFY_ActionSheetHeader.h"

@class TFY_PhotoProgressHUD;
@class TFY_PhotoItems;

typedef void(^PhotoBrowerSingleTap)(void);
typedef void(^PhotoBrowerLongPressTap)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoBrowserImageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SDAnimatedImageView *imageView;

@property (nonatomic,copy  ) PhotoBrowerSingleTap singleTap;

@property (nonatomic,copy  ) PhotoBrowerLongPressTap longPressTap;

- (void)imageWithUrl:(NSURL *)url
         progressHUD:(TFY_PhotoProgressHUD *)progressHUD
         placeHolder:(UIImage *)placeHolder
           photoItem:(TFY_PhotoItems *)photoItem;
@end

NS_ASSUME_NONNULL_END
