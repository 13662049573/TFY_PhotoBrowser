//
//  TFY_ActionSheet.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetBlock)(NSInteger buttonIndex);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ActionSheet : UIView

+ (TFY_ActionSheet *)share;

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
                  actionSheetBlock:(ActionSheetBlock)sheetBlock;

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             destructiveArray:(NSMutableArray <NSString *> *)destructiveArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock;


- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock;

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             destructiveArray:(NSMutableArray <NSString *> *)destructiveArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock;

- (void)showOnView:(UIView *)view;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
