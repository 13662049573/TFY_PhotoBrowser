//
//  TFY_Reachability.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "TFY_Reachability.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSString *const kPhotoReachabilityChangedNotification = @"kPhotoReachabilityChangedNotification";

@interface TFY_Reachability ()
@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;
@property (nonatomic, strong) dispatch_queue_t          reachabilitySerialQueue;
@property (nonatomic, strong) id                        reachabilityObject;

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;
- (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;
@end

static NSString *reachabilityFlags(SCNetworkReachabilityFlags flags){
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if    TARGET_OS_IPHONE
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
#else
            'X',
#endif
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
}

static void TMReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info){
#pragma unused (target)
    TFY_Reachability *reachability = ((__bridge TFY_Reachability*)info);
    @autoreleasepool{
        [reachability reachabilityChanged:flags];
    }
}


@implementation TFY_Reachability

+ (instancetype)reachabilityWithHostName:(NSString*)hostname{
    return [TFY_Reachability reachabilityWithHostname:hostname];
}

+ (instancetype)reachabilityWithHostname:(NSString*)hostname{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    if (ref)
    {
        id reachability = [[self alloc] initWithReachabilityRef:ref];

        return reachability;
    }
    
    return nil;
}

+ (instancetype)reachabilityWithAddress:(void *)hostAddress{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    if (ref)
    {
        id reachability = [[self alloc] initWithReachabilityRef:ref];
        
        return reachability;
    }
    
    return nil;
}

+ (instancetype)reachabilityForInternetConnection{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress:&zeroAddress];
}

+ (instancetype)reachabilityForLocalWiFi{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len            = sizeof(localWifiAddress);
    localWifiAddress.sin_family         = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr    = htonl(IN_LINKLOCALNETNUM);
    
    return [self reachabilityWithAddress:&localWifiAddress];
}

- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref{
    self = [super init];
    if (self != nil)
    {
        self.reachableOnWWAN = YES;
        self.reachabilityRef = ref;
        self.reachabilitySerialQueue = dispatch_queue_create("com.tonymillion.reachability", NULL);
    }
    
    return self;
}

- (void)dealloc{
    [self stopNotifier];
    if(self.reachabilityRef){
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }
    self.reachableBlock          = nil;
    self.unreachableBlock        = nil;
    self.reachabilityBlock       = nil;
    self.reachabilitySerialQueue = nil;
}

#pragma mark - Notifier Methods

- (BOOL)startNotifier{
    if(self.reachabilityObject && (self.reachabilityObject == self)){
        return YES;
    }
    SCNetworkReachabilityContext    context = { 0, NULL, NULL, NULL, NULL };
    context.info = (__bridge void *)self;

    if(SCNetworkReachabilitySetCallback(self.reachabilityRef, TMReachabilityCallback, &context)){
        if(SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue)){
            self.reachabilityObject = self;
            return YES;
        }else {
#ifdef DEBUG
            NSLog(@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));
#endif
            SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        }
    } else {
#ifdef DEBUG
        NSLog(@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
#endif
    }
    self.reachabilityObject = nil;
    return NO;
}

- (void)stopNotifier{
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);
    self.reachabilityObject = nil;
}

#pragma mark - reachability tests

#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

- (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags{
    BOOL connectionUP = YES;
    
    if(!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;
    
    if( (flags & testcase) == testcase )
        connectionUP = NO;
    
#if    TARGET_OS_IPHONE
    if(flags & kSCNetworkReachabilityFlagsIsWWAN){
        if(!self.reachableOnWWAN)
        {
            connectionUP = NO;
        }
    }
#endif
    return connectionUP;
}

- (BOOL)isReachable{
    SCNetworkReachabilityFlags flags;
    
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;
    
    return [self isReachableWithFlags:flags];
}

- (BOOL)isReachableViaWWAN{
#if    TARGET_OS_IPHONE
    SCNetworkReachabilityFlags flags = 0;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)){
        if(flags & kSCNetworkReachabilityFlagsReachable){
            if(flags & kSCNetworkReachabilityFlagsIsWWAN){
                return YES;
            }
        }
    }
#endif
    
    return NO;
}

- (BOOL)isReachableViaWiFi{
    SCNetworkReachabilityFlags flags = 0;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)){
        if((flags & kSCNetworkReachabilityFlagsReachable)){
#if    TARGET_OS_IPHONE
            if((flags & kSCNetworkReachabilityFlagsIsWWAN)){
                return NO;
            }
#endif
            return YES;
        }
    }
    return NO;
}

- (BOOL)isConnectionRequired{
    return [self connectionRequired];
}

- (BOOL)connectionRequired{
    SCNetworkReachabilityFlags flags;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)){
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    return NO;
}

- (BOOL)isConnectionOnDemand{
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)){
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
                (flags & (kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand)));
    }
    
    return NO;
}

- (BOOL)isInterventionRequired{
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)){
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
                (flags & kSCNetworkReachabilityFlagsInterventionRequired));
    }
    return NO;
}


#pragma mark - reachability status stuff

- (NetworkStatus)currentReachabilityStatus{
    if([self isReachable]){
        if([self isReachableViaWiFi])
            return ReachableViaWiFi;
#if    TARGET_OS_IPHONE
        return ReachableViaWWAN;
#endif
    }
    return NotReachable;
}

- (SCNetworkReachabilityFlags)reachabilityFlags{
    SCNetworkReachabilityFlags flags = 0;
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)){
        return flags;
    }
    return 0;
}

- (NSString *)currentReachabilityString{
    NetworkStatus temp = [self currentReachabilityStatus];
    if(temp == ReachableViaWWAN){
        return NSLocalizedString(@"Cellular", @"");
    }
    if (temp == ReachableViaWiFi){
        return NSLocalizedString(@"WiFi", @"");
    }
    return NSLocalizedString(@"No Connection", @"");
}

- (NSString *)currentReachabilityFlags{
    return reachabilityFlags([self reachabilityFlags]);
}

#pragma mark - Callback function calls this method

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags{
    if([self isReachableWithFlags:flags]){
        if(self.reachableBlock){
            self.reachableBlock(self);
        }
    }else{
        if(self.unreachableBlock){
            self.unreachableBlock(self);
        }
    }
    if(self.reachabilityBlock){
        self.reachabilityBlock(self, flags);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoReachabilityChangedNotification
                                                            object:self];
    });
}

@end
