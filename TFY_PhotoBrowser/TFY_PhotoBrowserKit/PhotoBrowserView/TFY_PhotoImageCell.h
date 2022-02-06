//
//  TFY_PhotoImageCell.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <UIKit/UIKit.h>
#import "TFY_PhotoBrowserImageView.h"

@class TFY_PhotoItems;

typedef void(^PhotoBrowerSingleTap)(void);
typedef void(^PhotoBrowerLongPressTap)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoImageCell : UICollectionViewCell

- (void)imageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder photoItem:(TFY_PhotoItems *)photoItem;

@property (nonatomic,strong) TFY_PhotoBrowserImageView *photoBrowerImageView;
@property (nonatomic,copy  ) PhotoBrowerSingleTap singleTap;
@property (nonatomic,copy  ) PhotoBrowerLongPressTap longPressTap;
@property (nonatomic,assign) UIViewContentMode presentedMode;

@end

NS_ASSUME_NONNULL_END
