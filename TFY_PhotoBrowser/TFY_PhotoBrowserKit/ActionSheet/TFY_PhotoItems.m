//
//  TFY_PhotoItems.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "TFY_PhotoItems.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>

@implementation TFY_PhotoItems
@end

@implementation UIDevice(Extension)

+ (void)deviceAlbumAuth:(void (^)(BOOL isAuthor))authorBlock{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        if(authorBlock){
            authorBlock(false);
        }
    } else if (status == PHAuthorizationStatusDenied) {
        if(authorBlock){
            authorBlock(false);
        }
    } else if (status == PHAuthorizationStatusAuthorized) {
        if(authorBlock){
            authorBlock(true);
        }
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(authorBlock){
                        authorBlock(true);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(authorBlock){
                        authorBlock(false);
                    }
                });
            }
        }];
    }
}

/// device shake
+ (void)deviceShake{
    AudioServicesPlaySystemSound(1520);
}

@end
