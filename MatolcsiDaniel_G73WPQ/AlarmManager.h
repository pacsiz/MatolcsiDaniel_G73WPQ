//
//  AlarmManager.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.05.04..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarms.h"
#import "alarmDB.h"


@interface AlarmManager : NSObject

+(NSArray*)doesAlarmExistByName:(NSString *)alarmName;
+(Alarms*) setAlarmDetailsOf:(Alarms *)alarm alarmName:(NSString *)alarmName alarmDay:(NSNumber *)alarmDay alarmWeek:(NSNumber *)alarmWeek alarmDate:(NSDate* )alarmDate;
+(void)saveAlarmDB;
+(Alarms*)newAlarm;

@end
