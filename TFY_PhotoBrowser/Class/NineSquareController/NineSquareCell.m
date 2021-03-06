//
//  NineSquareCell.m
//  TFY_PhotoBrowser
//
//  Created by LuKane on 2021/5/18.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "NineSquareCell.h"
#import <SDAnimatedImageView.h>
#import <UIImageView+WebCache.h>
#import <UIKit/UIKit.h>

#import "TFY_PhotoBrowser.h"

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

@interface NineSquareCell()<PhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *imgArray;

@property (nonatomic,strong) NSMutableArray *photoItemsArr;

@end

@implementation NineSquareCell

- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

+ (instancetype)nineSquareCell:(UITableView *)tableView{
    static NSString *ID = @"NineSquareCellID";
    NineSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NineSquareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = UIColor.whiteColor;
        cell.contentView.backgroundColor = UIColor.whiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    self.photoItemsArr = [NSMutableArray array];
    CGFloat width = (ScreenWidth - 40) / 3;
    for (NSInteger i = 0; i < 9; i++) {
        
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        
        SDAnimatedImageView *imgView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        imgView.userInteractionEnabled = true;
        imgView.tag = i;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
        imgView.hidden = true;
        [self.contentView addSubview:imgView];
        [_imgArray addObject:imgView];
    }
}

- (void)setSquareM:(NineSquareModel *)squareM{
    _squareM = squareM;
    [self.photoItemsArr removeAllObjects];
    if (_isLocate == false) {
        for (NSInteger i = 0; i < _imgArray.count; i++) {
            UIImageView *imageView = _imgArray[i];
            if (i < squareM.urlArr.count) {
                imageView.hidden = false;
                NineSquareItemsModel *itemM = squareM.urlArr[i];
                if (i != 7 && i != 8) {
                    if ( i == 1) {
                        // locate video , get the first image of video
                        AVURLAsset *avAsset = nil;
                        avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:itemM.photoUrl]];
                        if (avAsset) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                                generator.appliesPreferredTrackTransform = YES;
                                NSError *error = nil;
                                CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    imageView.image = [UIImage imageWithCGImage:cgImage];
                                });
                            });
                        }
                    }else if (i == 2 || i == 3){
                        [imageView sd_setImageWithURL:[NSURL URLWithString:itemM.placeHolderUrl] placeholderImage:nil];
                    }else {
                        [imageView sd_setImageWithURL:[NSURL URLWithString:itemM.photoUrl] placeholderImage:nil];
                    }
                    TFY_PhotoItems *photoItems = [[TFY_PhotoItems alloc] init];
                    photoItems.sourceView = imageView;
                    if(i == 2 || i == 3){
                        photoItems.isVideo = true;
                        photoItems.photoUrl = itemM.photoUrl;
                        photoItems.videoPlaceHolderImageUrl = itemM.placeHolderUrl;
                    }else if (i == 1){
                        photoItems.isVideo = true;
                        photoItems.photoUrl = itemM.photoUrl;
                    }else {
                        photoItems.photoUrl = [itemM.photoUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                    }
                    [self.photoItemsArr addObject:photoItems];
                }else if (i == 7) {
                    NSData *data = [NSData dataWithContentsOfFile:itemM.photoUrl];
                    SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:data];
                    imageView.image = animatedImage;
                    
                    TFY_PhotoItems *photoItems = [[TFY_PhotoItems alloc] init];
                    photoItems.sourceView = imageView;
                    photoItems.photoUrl = [itemM.photoUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                    [self.photoItemsArr addObject:photoItems];
                }else if (i == 8) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:itemM.photoUrl] placeholderImage:nil];
                    TFY_PhotoItems *photoItems = [[TFY_PhotoItems alloc] init];
                    photoItems.sourceView = imageView;
                    photoItems.photoUrl = [itemM.photoUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                    [self.photoItemsArr addObject:photoItems];
                }
            }else {
                imageView.hidden = true;
            }
        }
    }else {
        for (NSInteger i = 0; i < _imgArray.count; i++) {
            UIImageView *imageView = _imgArray[i];
            if (i < squareM.urlArr.count) {
                imageView.hidden = false;
                NineSquareItemsModel *itemM = squareM.urlArr[i];
                
                TFY_PhotoItems *photoItems = [[TFY_PhotoItems alloc] init];
                photoItems.sourceView = imageView;
                
                if ( i == 1) {
                    // locate video , get the first image of video
                    AVURLAsset *avAsset = nil;
                    avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:itemM.photoUrl]];
                    if (avAsset) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                            generator.appliesPreferredTrackTransform = YES;
                            NSError *error = nil;
                            CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                imageView.image = [UIImage imageWithCGImage:cgImage];
                                photoItems.sourceImage = [UIImage imageWithCGImage:cgImage];
                            });
                        });
                    }
                    photoItems.isVideo = true;
                    photoItems.photoUrl = itemM.photoUrl;
                }else {
                    imageView.image = [UIImage imageNamed:itemM.photoUrl];
                    photoItems.sourceImage = [UIImage imageNamed:itemM.photoUrl];
                }
                [self.photoItemsArr addObject:photoItems];
            }else {
                imageView.hidden = true;
            }
        }
    }
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap {
    TFY_PhotoBrowser *photoBrowser = [[TFY_PhotoBrowser alloc] init];
    
    photoBrowser.itemsArr = [self.photoItemsArr copy];
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.delegate = self;
    
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedLongPress = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedOnlinePlay = true;
    
    [photoBrowser presentOn:[self currentController:self]];
}

- (UIViewController *)currentController:(UIView *)view{
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    return nil;
}

/**************************** == delegate == ******************************/
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser willDismissWithIndex:(NSInteger)index {
    NSLog(@"willDismissWithIndex:%zd",index);
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index{
    TFY_ActionSheet *actionSheet = [[TFY_ActionSheet share] initWithTitle:@""
                                                          cancelTitle:@"取消"
                                                           titleArray:@[@"删除",@"保存",@"喜欢"].mutableCopy
                                                     destructiveArray:@[@"0"].mutableCopy
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%zd",buttonIndex);
        
        if (buttonIndex == 0) {
            [photoBrowser removeImageOrVideoOnPhotoBrowser];
        }
        
        if (buttonIndex == 1) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [photoBrowser downloadImageOrVideoToAlbum];
                }
            }];
        }
    }];
    [actionSheet showOnView:photoBrowser.view];
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser imageLongPressWithIndex:(NSInteger)index{
    
    TFY_ActionSheet *actionSheet = [[TFY_ActionSheet share] initWithTitle:@""
                                                          cancelTitle:@"取消"
                                                           titleArray:@[@"保存",@"喜欢"].mutableCopy
                                                     destructiveArray:@[].mutableCopy
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [photoBrowser downloadImageOrVideoToAlbum];
                }
            }];
        }
    }];
    [actionSheet showOnView:photoBrowser.view];
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser videoLongPress:(UILongPressGestureRecognizer *)longPress index:(NSInteger)index{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIDevice deviceShake];
        [photoBrowser setImmediatelyPlayerRate:2];
    }else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed || longPress.state == UIGestureRecognizerStateRecognized){
        [photoBrowser setImmediatelyPlayerRate:1];
    }
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser removeSourceWithRelativeIndex:(NSInteger)relativeIndex{
    NSLog(@"removeSourceWithRelativeIndex:%zd",relativeIndex);
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser removeSourceWithAbsoluteIndex:(NSInteger)absoluteIndex{
    NSLog(@"removeSourceWithAbsoluteIndex:%zd",absoluteIndex);
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser scrollToLocateWithIndex:(NSInteger)index{
    NSLog(@"scrollToLocateWithIndex:%zd",index);
}
- (void)photoBrowser:(TFY_PhotoBrowser *)photoBrowser state:(PhotoDownloadState)state progress:(float)progress photoItemRelative:(TFY_PhotoItems *)photoItemRe photoItemAbsolute:(TFY_PhotoItems *)photoItemAb {
    NSLog(@"%@ ===> %ld -- %f",photoBrowser,(long)state,progress);
}

@end
