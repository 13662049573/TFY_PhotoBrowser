//
//  TFY_PhotoPlayerProtocol.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoPlayerViewDelegate <NSObject>
- (void)photoPlayerViewDismiss;
- (void)photoPlayerLongPress:(UILongPressGestureRecognizer *)longPress;
@end

NS_ASSUME_NONNULL_END
