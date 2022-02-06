//
//  TFY_ActionSheetItem.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetItemDelegate <NSObject>
/// 点击代理
- (void)actionSheetItemDidClick:(NSInteger)index;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ActionSheetItem : UIView
/// delegate
@property (nonatomic , weak) id<ActionSheetItemDelegate> delegate;
/// title
@property (nonatomic , copy) NSString *title;
/// title color
@property (nonatomic , copy) UIColor *color;

@end

NS_ASSUME_NONNULL_END
