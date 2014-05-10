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
    {
        NSLog(@"%@",error.description);
    }
    [alarmDB setContext:[[NSManagedObjectContext alloc] init]];
    [[alarmDB context] setPersistentStoreCoordinator:[alarmDB store]];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSError *error;
    [[alarmDB context] save:&error];
    app = [UIApplication sharedApplication];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{}

- (void)applicationDidBecomeActive:(UIApplication *)application
{}

- (void)applicationWillTerminate:(UIApplication *)application
{}


- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    
    //elsült notification törlése
    NSString *notifName = [notif.userInfo objectForKey:@"key"];
    [NotificationManager deleteNotificationByAlarmName:notifName];
    
    //ha nem szundiról van szó, adott ébresztés beállítása a köv. időpontra
    if (![notifName isEqualToString:@"snooze"]) {
        NSArray *alarm = [AlarmManager doesAlarmExistByName:notifName];
        [NotificationManager setNewLocalNotification:alarm[0]];
    }
    
    //lenyomjuk az ébresztést vagy szundi
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