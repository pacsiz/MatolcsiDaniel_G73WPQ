//
//  AppDelegate.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 4/9/14.
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    UIApplication *app;
    NSTimer* timer;
    int szam;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL* docDir =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    NSURL* storeURL = [docDir URLByAppendingPathComponent:@"alarmdb.sqlite"];
    NSError* error;
    
    [alarmDB setModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]];
    [alarmDB setStore:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[alarmDB model]]];
    [[alarmDB store] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (error)
        NSLog(@"%@",error.description);
    
    [alarmDB setContext:[[NSManagedObjectContext alloc] init]];
    [[alarmDB context] setPersistentStoreCoordinator:[alarmDB store]];
   
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSError *error;
    [[alarmDB context] save:&error];
    app = [UIApplication sharedApplication];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    
    NSString *notifName = [notif.userInfo objectForKey:@"key"];
    [NotificationManager deleteNotificationByAlarmName:notifName];
    
    if (![notifName isEqualToString:@"snooze"]) {
        NSArray *alarm = [AlarmManager doesAlarmExistByName:notifName];
        [NotificationManager setNewLocalNotification:alarm[0]];
    }
    
//  Regisztrál notif check
//    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    NSLog(@"Ntoi tömb mérete: %d", [notifications count]);
//    for (UILocalNotification *notif in notifications) {
//        NSDictionary *current = notif.userInfo;
//        NSLog(@"Létező notif: %@:",current);
//        NSLog(@"notif firedat: %@", notif.fireDate);
//        NSLog(@"Rendszerdátum: %@",[NSDate date]);
//    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ébresztés"
                                                   message:@"Fel kelsz, vagy szundi?"
                                                  delegate:self
                                         cancelButtonTitle:@"Igen"
                                         otherButtonTitles:@"Szundi",nil];
    [alert show];
    
   
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSLog(@"Szundit nyomott");
        NSDate *currentDate = [NSDate date];
        
        [NotificationManager setNewSnoozeNotification:currentDate];
    }
    else
    {
        [NotificationManager deleteNotificationByAlarmName:@"snooze"];
    }
}


@end