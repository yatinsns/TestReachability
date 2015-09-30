#import "RIVANetworkReachability.h"
#import "Reachability+RIVAIPv6Additions.h"

NSString *const RIVANetworkReachabilityDidChangeNotification = @"TDTReachabilityDidChangeNotification";

@interface RIVANetworkReachability ()

@property (nonatomic) Reachability *reachabilityIPv4;
@property (nonatomic) Reachability *reachabilityIPv6;

@property (nonatomic, getter=isReachable) BOOL reachable;

@end

@implementation RIVANetworkReachability

+ (RIVANetworkReachability *)reachabilityForInternetConnection {
  return [[RIVANetworkReachability alloc] init];
}

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    _reachabilityIPv4 = [Reachability reachabilityForInternetConnection];
    _reachabilityIPv6 = [Reachability riva_reachabilityForInternetConnectionIPv6Only];
    
    _reachable = [_reachabilityIPv4 isReachable] || [_reachabilityIPv6 isReachable];
  }
  return self;
}

- (void)dealloc {
  [_reachabilityIPv4 stopNotifier];
  [_reachabilityIPv6 stopNotifier];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifier methods

- (void)startNotifier {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityDidChangeNotification:)
                                               name:kReachabilityChangedNotification
                                             object:self.reachabilityIPv4];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityDidChangeNotification:)
                                               name:kReachabilityChangedNotification
                                             object:self.reachabilityIPv6];
  
  [self.reachabilityIPv4 startNotifier];
  [self.reachabilityIPv6 startNotifier];
}

- (void)stopNotifier {
  [self.reachabilityIPv4 stopNotifier];
  [self.reachabilityIPv6 stopNotifier];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Reachability changes

- (void)reachabilityDidChangeNotification:(NSNotification *)notification {
  [self updateReachablilityStatus];
}

- (void)updateReachablilityStatus {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.reachable = [self.reachabilityIPv4 isReachable] || [self.reachabilityIPv6 isReachable];
  });
}

- (void)setReachable:(BOOL)reachable {
  if (_reachable != reachable) {
    _reachable = reachable;
    [[NSNotificationCenter defaultCenter] postNotificationName:RIVANetworkReachabilityDidChangeNotification
                                                        object:self];
  }
}

@end
