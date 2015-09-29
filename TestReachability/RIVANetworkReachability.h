#import <Foundation/Foundation.h>

/**
 This notification is posted whenever reachability changes.
 This is posted on MAIN THREAD only.
 */
extern NSString *const RIVANetworkReachabilityDidChangeNotification;

/**
 This class acts as a wrapper on `Reachability`.
 It provides tracking on internet connection for both IPv4 and IPv6 networks.
 */
@interface RIVANetworkReachability : NSObject

+ (RIVANetworkReachability *)reachabilityForInternetConnection;

- (BOOL)isReachable;

- (void)startNotifier;
- (void)stopNotifier;

@end
