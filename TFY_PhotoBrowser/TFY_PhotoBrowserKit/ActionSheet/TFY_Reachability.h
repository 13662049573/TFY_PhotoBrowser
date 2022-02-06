//
//  TFY_Reachability.h
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

extern NSString * _Nonnull const kPhotoReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class TFY_Reachability;

typedef void (^NetworkReachable)(TFY_Reachability * _Nonnull reachability);
typedef void (^NetworkUnreachable)(TFY_Reachability * _Nonnull reachability);
typedef void (^NetworkReachability)(TFY_Reachability * _Nonnull reachability, SCNetworkConnectionFlags flags);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_Reachability : NSObject

@property (nonatomic, copy, nullable) NetworkReachable    reachableBlock;
@property (nonatomic, copy, nullable) NetworkUnreachable  unreachableBlock;
@property (nonatomic, copy, nullable) NetworkReachability reachabilityBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;

+ (instancetype)reachabilityWithHostname:(NSString*)hostname;
+ (instancetype)reachabilityWithHostName:(NSString*)hostname;
+ (instancetype)reachabilityForInternetConnection;
+ (instancetype)reachabilityWithAddress:(void *)hostAddress;
+ (instancetype)reachabilityForLocalWiFi;

- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;
- (BOOL)startNotifier;
- (void)stopNotifier;
- (BOOL)isReachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;
- (BOOL)isConnectionRequired;
- (BOOL)connectionRequired;
- (BOOL)isConnectionOnDemand;
- (BOOL)isInterventionRequired;
- (NetworkStatus)currentReachabilityStatus;
- (SCNetworkReachabilityFlags)reachabilityFlags;
- (NSString *)currentReachabilityString;
- (NSString *)currentReachabilityFlags;

@end

NS_ASSUME_NONNULL_END
