#import <Reachability/Reachability.h>

@interface Reachability (RIVAIPv6Additions)

/**
 Creates and return a new `Reachability` object initialized to track reachability
 in IPv6 only network.
 */
+ (Reachability *)riva_reachabilityForInternetConnectionIPv6Only;

@end
