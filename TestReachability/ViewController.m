//
//  ViewController.m
//  TestReachability
//
//  Created by Yatin on 9/26/15.
//  Copyright (c) 2015 Yatin. All rights reserved.
//

#import "ViewController.h"
#import <Reachability.h>

@interface ViewController () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reachabilityWithInternetConnectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *reachabilityWithHostnameStatus;

@property (nonatomic) Reachability *reachabilityWithInternetConnection;
@property (nonatomic) Reachability *reachabilityWithHostname;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    _reachabilityWithInternetConnection = [Reachability reachabilityForInternetConnection];
    _reachabilityWithHostname = [Reachability reachabilityWithHostName:@"www.flock1212.org"];
    
    [_reachabilityWithHostname startNotifier];
    [_reachabilityWithInternetConnection startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChangeNotification:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateStatusLabels];
}

- (void)updateStatusLabels {
  [self updateStatusLabel:self.reachabilityWithInternetConnectionStatus
              isReachable:[self.reachabilityWithInternetConnection isReachable]];
  [self updateStatusLabel:self.reachabilityWithHostnameStatus
              isReachable:[self.reachabilityWithHostname isReachable]];
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
  [self updateStatusLabels];
}

@end
