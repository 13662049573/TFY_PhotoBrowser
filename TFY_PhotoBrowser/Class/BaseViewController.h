//
//  BaseViewController.h
//  TFY_PhotoBrowser
//
//  Created by LuKane on 2018/12/14.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

@interface BaseViewController : UIViewController

- (UIImage *)createImageWithUIColor:(UIColor *)imageColor;

@end

NS_ASSUME_NONNULL_END
