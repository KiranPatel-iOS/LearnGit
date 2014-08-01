//
//  AppDelegate.h
//  BLELinkedinPOC
//
//  Created by Kiran Patel on 06/05/14.
//  Copyright (c) 2014 Solution Analysts Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MCManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *homeView;
@property (nonatomic, strong) MCManager *mcManager;
@end
