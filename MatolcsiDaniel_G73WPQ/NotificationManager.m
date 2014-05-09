//
//  NotificationManager.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.05.04..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager


+(void)setNewLocalNotification:(Alarms *)currentAlarm
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] isEqualToString:@"off"]) {
    
    NSLog(@"Új alarm: %@,", currentAlarm.alarmname);
    NSDate *currentDate  = [NSDate date];
    NSLog(@"CurrentDate: %@",currentDate);
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorianCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CEST"]];
    gregorianCalendar.firstWeekday = 2;
    
    NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit| NSMonthCalendarUnit
                                                                  | NSDayCalendarUnit| NSWeekdayCalendarUnit|NSWeekCalendarUnit|NSMinuteCalendarUnit |NSHourCalendarUnit)  fromDate:currentDate];
    
    
    NSDateComponents *dt=[[NSDateComponents alloc]init];
    [dt setWeekday:currentAlarm.alarmday.intValue];
    [dt setHour:currentAlarm.alarmhour.intValue];
    [dt setMinute:currentAlarm.alarmminute.intValue];
     NSLog(@"DT WD: %d, DT D: %D, C WD: %d, C D: %D",dt.weekday,dt.day,components.weekday,components.day);
    
    if ((dt.weekday == components.weekday && ((dt.hour <= components.hour && dt.minute <= components.minute))) || (dt.weekday < components.weekday))
    {
        NSLog(@"DT: %d:%d", dt.hour, dt.minute);
        NSLog(@"Components: %d:%d", components.hour, components.minute);
        if(dt.weekday != 1)
        components.week = components.week+1;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    switch (currentAlarm.alarmweek.intValue) {
        case 0:
        {
            dt = [self setNotificationDateforAlarm:currentAlarm byComponent:components andParity:NO];
            break;
        }
        case 1:
        {
            if ([components week]%2 != 1) {
                
                dt = [self setNotificationDateforAlarm:currentAlarm byComponent:components andParity:YES];
            }
            else
            {
                dt = [self setNotificationDateforAlarm:currentAlarm byComponent:components andParity:NO];
            }
            break;
        }
        case 2:
        {
            if ([components week]%2 != 0) {
                dt = [self setNotificationDateforAlarm:currentAlarm byComponent:components andParity:YES];
            }
            else
            {
                dt = [self setNotificationDateforAlarm:currentAlarm byComponent:components andParity:NO];
            }
            
            break;
        }
        default:
            break;
    }
    
    //NSLog(@"Mentés: %d,%d,%d, %d:%d:%d",dt.year,dt.month,dt.week, dt.hour, dt.minute, dt.second);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:currentAlarm.alarmname forKey:@"key"];
    notification.userInfo = userInfo;
    notification.alertBody = @"Ébresztés";
    notification.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CEST"];
    notification.soundName = @"alarm.wav";
    NSDate *notificationDate = [gregorianCalendar dateFromComponents:dt];
    notification.fireDate = notificationDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"dátum: %@",notificationDate);
    }
}

+(NSDateComponents*)setNotificationDateforAlarm:(Alarms *)alarm byComponent:(NSDateComponents *)components andParity:(BOOL)parity
{
    NSDateComponents *dt=[[NSDateComponents alloc]init];
    // NSLog(@"%d",[components week]);
    if(parity)
    {
        [dt setWeekOfYear:[components week]+1];
        //NSLog(@"NEM mindenhét: %d",dt.weekOfYear);
    }
    else
    {
        [dt setWeekOfYear:[components week]];
        //NSLog(@"mindenhét: %d",dt.weekOfYear);
    }
    
    [dt setWeekday:alarm.alarmday.intValue];
    [dt setYear:[components year]];
    [dt setHour:alarm.alarmhour.intValue];
    [dt setMinute:alarm.alarmminute.intValue];
    [dt setSecond:0];
    // NSLog(@"dt: %d", [dt weekOfYear]);
    return dt;
}

+(void)setNewSnoozeNotification:(NSDate* )date
{
    NSInteger snooze =  [[NSUserDefaults standardUserDefaults] integerForKey:@"snooze"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorianCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CEST"]];
    gregorianCalendar.firstWeekday = 2;
    NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit| NSMonthCalendarUnit
                                                                  | NSDayCalendarUnit| NSWeekdayCalendarUnit|NSWeekCalendarUnit|NSMinuteCalendarUnit |NSHourCalendarUnit)  fromDate:date];
    
    [components setSecond:0];
    [components setMinute:(components.minute+snooze)];
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"snooze",@"key", nil];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.userInfo = userInfo;
    notification.alertBody = @"Ébresztés";
    notification.soundName = @"alarm.wav";
    NSDate *notificationDate = [gregorianCalendar dateFromComponents:components];
    notification.fireDate = notificationDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"dátum: %@",notificationDate);

}


+(void)deleteNotificationByAlarmName:(NSString *) alarmName
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *not in notifications) {
        if([[not.userInfo valueForKey:@"key"] isEqualToString:alarmName])
        {
            NSLog(@"If: %@",[not.userInfo valueForKey:@"key"]);
            notification = not;
        }
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:notification];

}

+(void)deleteAllNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+(void)setNotificationForAllAlarm
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Alarms"];

    NSArray *alarms = [[alarmDB context] executeFetchRequest:request error:nil];
    
    for (Alarms *alarm in alarms) {
        [self setNewLocalNotification:alarm];
    }
   
}
@end

