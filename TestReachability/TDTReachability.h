#import <Foundation/Foundation.h>

extern NSString *const TDTReachabilityDidChangeNotification;

@interface TDTReachability : NSObject

@property (nonatomic, readonly) BOOL isReachable;

+ (TDTReachability *)reachabilityForInternetConnection;

- (BOOL)isReachable;

@end
