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

@interface ViewController () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reachabilityForInternetConnectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *reachabilityWithHostnameStatus;
@property (weak, nonatomic) IBOutlet UILabel *gcReachabilityForInternetConnectionStatus;

@property (nonatomic) Reachability *reachabilityForInternetConnection;
@property (nonatomic) Reachability *reachabilityWithHostname;

@property (nonatomic) GCNetworkReachability *gcReachabilityForInternetConnection;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    _reachabilityForInternetConnection = [Reachability reachabilityForInternetConnection];
    _reachabilityWithHostname = [Reachability reachabilityWithHostName:@"www.flock1212.org"];
    
    [_reachabilityWithHostname startNotifier];
    [_reachabilityForInternetConnection startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChangeNotification:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    _gcReachabilityForInternetConnection = [GCNetworkReachability reachabilityForInternetConnection];
    [_gcReachabilityForInternetConnection startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
      [self updateGCReachabilityStatusLabels];
    }];
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
  [self updateStatusLabel:self.reachabilityForInternetConnectionStatus
              isReachable:[self.reachabilityForInternetConnection isReachable]];
  [self updateStatusLabel:self.reachabilityWithHostnameStatus
              isReachable:[self.reachabilityWithHostname isReachable]];
}

@end
