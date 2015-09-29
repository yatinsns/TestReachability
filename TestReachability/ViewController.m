//
//  ViewController.m
//  TestReachability
//
//  Created by Yatin on 9/26/15.
//  Copyright (c) 2015 Yatin. All rights reserved.
//

#import "ViewController.h"
#import <Reachability.h>
#import <GCNetworkReachability/GCNetworkReachability.h>
#import <netinet6/in6.h>
#import "RIVANetworkReachability.h"

@interface ViewController () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reachabilityForInternetConnectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *reachabilityWithHostnameStatus;
@property (weak, nonatomic) IBOutlet UILabel *gcReachabilityForInternetConnectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *gcReachabilityForInternetConnectionIPv6OnlyStatus;
@property (weak, nonatomic) IBOutlet UILabel *tdtReachabilityStatus;

@property (nonatomic) Reachability *reachabilityForInternetConnection;
@property (nonatomic) Reachability *reachabilityWithHostname;

@property (nonatomic) GCNetworkReachability *gcReachabilityForInternetConnection;
@property (nonatomic) GCNetworkReachability *gcReachabilityForInternetConnectionIPv6Only;

@property (nonatomic) RIVANetworkReachability *tdtReachability;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    _reachabilityForInternetConnection = [Reachability reachabilityForInternetConnection];
    _reachabilityWithHostname = [Reachability reachabilityWithHostName:@"www.flock.co"];
    
    [_reachabilityWithHostname startNotifier];
    [_reachabilityForInternetConnection startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChangeNotification:)
                                                 name:kReachabilityChangedNotification
                                               object:_reachabilityWithHostname];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChangeNotification:)
                                                 name:kReachabilityChangedNotification
                                               object:_reachabilityForInternetConnection];
    
    _gcReachabilityForInternetConnection = [GCNetworkReachability reachabilityForInternetConnection];
    [_gcReachabilityForInternetConnection startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
      [self updateGCReachabilityStatusLabels];
    }];
    
    _gcReachabilityForInternetConnectionIPv6Only = [GCNetworkReachability reachabilityWithIPv6Address:in6addr_any];
    [_gcReachabilityForInternetConnectionIPv6Only startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
      [self updateGCReachabilityStatusLabels];
    }];
    
    _tdtReachability = [RIVANetworkReachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tdtReachabilityDidChangeNotification:)
                                                 name:RIVANetworkReachabilityDidChangeNotification
                                               object:_tdtReachability];
    [_tdtReachability startNotifier];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateAllStatusLabels];
}

- (void)updateAllStatusLabels {
  [self updateReachabilityStatusLabels];
  [self updateGCReachabilityStatusLabels];
  [self updateTDTReachabilityStatusLabel];
}

- (void)updateReachabilityStatusLabels {
  [self updateStatusLabel:self.reachabilityForInternetConnectionStatus
              isReachable:[self.reachabilityForInternetConnection isReachable]];
  [self updateStatusLabel:self.reachabilityWithHostnameStatus
              isReachable:[self.reachabilityWithHostname isReachable]];
}

- (void)updateGCReachabilityStatusLabels {
  [self updateStatusLabel:self.gcReachabilityForInternetConnectionStatus
              isReachable:[self.gcReachabilityForInternetConnection isReachable]];
  [self updateStatusLabel:self.gcReachabilityForInternetConnectionIPv6OnlyStatus
              isReachable:[self.gcReachabilityForInternetConnectionIPv6Only isReachable]];
}

- (void)updateTDTReachabilityStatusLabel {
  [self updateStatusLabel:self.tdtReachabilityStatus
              isReachable:[self.tdtReachability isReachable]];
}

- (void)updateStatusLabel:(UILabel *)statusLabel isReachable:(BOOL)isReachable {
  if (isReachable) {
    [self updateLabel:statusLabel withText:@"Reachable" textColor:[UIColor greenColor]];
  } else {
    [self updateLabel:statusLabel withText:@"Unreachable" textColor:[UIColor redColor]];
  }
}

- (void)updateLabel:(UILabel *)label
           withText:(NSString *)text
          textColor:(UIColor *)textColor {
  label.text = text;
  label.textColor = textColor;
}

- (void)reachabilityDidChangeNotification:(NSNotification *)notification {
  [self updateReachabilityStatusLabels];
}

- (void)tdtReachabilityDidChangeNotification:(NSNotification *)notification {
  [self updateTDTReachabilityStatusLabel];
}

@end
