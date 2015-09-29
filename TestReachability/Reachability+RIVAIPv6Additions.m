#import "Reachability+RIVAIPv6Additions.h"
#import <netinet6/in6.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation Reachability (RIVAIPv6Additions)

+ (Reachability *)riva_reachabilityForInternetConnectionIPv6Only {
  char strAddr[INET6_ADDRSTRLEN];
  
  struct sockaddr_in6 addr;
  memset(&addr, 0, sizeof(struct sockaddr_in6));
  (&addr)->sin6_len = sizeof(struct sockaddr_in6);
  (&addr)->sin6_family = AF_INET6;
  addr.sin6_addr = in6addr_any;
  inet_ntop(AF_INET6, &addr.sin6_addr, strAddr, INET6_ADDRSTRLEN);
  inet_pton(AF_INET6, strAddr, &addr.sin6_addr);
  
  SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault,
                                                                        (const struct sockaddr*)&addr);
  if (ref != nil) {
    Reachability *reachability = [[self alloc] initWithReachabilityRef:ref];
    return reachability;
  }

  return nil;
}

@end
