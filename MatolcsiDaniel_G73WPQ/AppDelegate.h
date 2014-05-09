//
//  AppDelegate.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 4/9/14.
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "alarmDB.h"
#import "NotificationManager.h"
#import "AlarmManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UILocalNotification *localNotif;

@end
