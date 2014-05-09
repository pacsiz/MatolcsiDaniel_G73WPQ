//
//  NotificationManager.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.05.04..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarms.h"
#import "alarmDB.h"
@interface NotificationManager : NSObject

+(void)setNewLocalNotification:(Alarms *)currentAlarm;
+(NSDateComponents*)setNotificationDateforAlarm:(Alarms *)alarm byComponent:(NSDateComponents *)components andParity:(BOOL)parity;
+(void)deleteNotificationByAlarmName:(NSString *) alarmName;
+(void)setNewSnoozeNotification:(NSDate* )date;
+(void)setNotificationForAllAlarm;
+(void)deleteAllNotification;
@end
