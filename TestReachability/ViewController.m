//
//  ViewController.m
//  TestReachability
//
//  Created by Yatin on 9/26/15.
//  Copyright (c) 2015 Yatin. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, ReachabilityState) {
  ReachabilityStateUnreachable,
  ReachabilityStateReachable
};

@interface ViewController () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reachabilityWithInternetConnectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *reachabilityWithHostnameStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateStatusLabel:self.reachabilityWithInternetConnectionStatus
    withReachabilityState:ReachabilityStateUnreachable];
  [self updateStatusLabel:self.reachabilityWithHostnameStatus
    withReachabilityState:ReachabilityStateReachable];
}

- (void)updateStatusLabel:(UILabel *)statusLabel
    withReachabilityState:(ReachabilityState)reachabilityState {
  switch (reachabilityState) {
    case ReachabilityStateUnreachable:
      [self updateLabel:statusLabel withText:@"Unreachable" textColor:[UIColor redColor]];
      break;
      
    case ReachabilityStateReachable:
      [self updateLabel:statusLabel withText:@"Reachable" textColor:[UIColor greenColor]];
      break;
  }
}

- (void)updateLabel:(UILabel *)label
           withText:(NSString *)text
          textColor:(UIColor *)textColor {
  label.text = text;
  label.textColor = textColor;
}

@end
