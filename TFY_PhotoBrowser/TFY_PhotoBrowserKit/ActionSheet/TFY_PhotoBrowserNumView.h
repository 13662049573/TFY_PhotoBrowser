//
//  TFY_PhotoBrowserNumView.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoBrowserNumView : UILabel

- (void)setCurrentNum:(NSInteger)currentNum totalNum:(NSInteger)totalNum;

@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) NSInteger totalNum;

@end

NS_ASSUME_NONNULL_END
