#import "TDTReachability.h"
#import <GCNetworkReachability/GCNetworkReachability.h>
#import <netinet6/in6.h>

NSString *const TDTReachabilityDidChangeNotification = @"TDTReachabilityDidChangeNotification";

@interface TDTReachability ()

@property (nonatomic) GCNetworkReachability *reachabilityIPv4;
@property (nonatomic) GCNetworkReachability *reachabilityIPv6;

@property (nonatomic, readwrite) BOOL isReachable;

@end

@implementation TDTReachability

+ (TDTReachability *)reachabilityForInternetConnection {
  return [[TDTReachability alloc] init];
}

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    _reachabilityIPv4 = [GCNetworkReachability reachabilityForInternetConnection];
    _reachabilityIPv6 = [GCNetworkReachability reachabilityWithIPv6Address:in6addr_any];
    
    _isReachable = [_reachabilityIPv4 isReachable] || [_reachabilityIPv6 isReachable];
    
    [_reachabilityIPv4 startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
      [self updateReachablilityStatus];
    }];
    
    [_reachabilityIPv6 startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
      [self updateReachablilityStatus];
    }];
  }
  return self;
}

- (void)updateReachablilityStatus {
  self.isReachable = [self.reachabilityIPv4 isReachable] || [self.reachabilityIPv6 isReachable];
}

- (void)setIsReachable:(BOOL)isReachable {
  if (_isReachable != isReachable) {
    _isReachable = isReachable;
    [[NSNotificationCenter defaultCenter] postNotificationName:TDTReachabilityDidChangeNotification
                                                        object:self];
  }
}

@end
