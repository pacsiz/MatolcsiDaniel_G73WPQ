//
//  AlarmManager.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.05.04..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "AlarmManager.h"

@implementation AlarmManager

+(Alarms*)newAlarm
{
    Alarms *newAlarm = [NSEntityDescription insertNewObjectForEntityForName:@"Alarms" inManagedObjectContext:[alarmDB context]];
    
    return newAlarm;
}

+(NSArray*)doesAlarmExistByName:(NSString *)alarmName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Alarms"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"alarmname == %@", alarmName];
    
    [request setPredicate:pre];
    NSArray *alarmExist = [[alarmDB context] executeFetchRequest:request error:nil];
    
    return alarmExist;
}

+(Alarms*) setAlarmDetailsOf:(Alarms *)alarm alarmName:(NSString *)alarmName alarmDay:(NSNumber *)alarmDay alarmWeek:(NSNumber *)alarmWeek alarmDate:(NSDate *)alarmDate
{
    [alarm setAlarmname:alarmName];
    [alarm setAlarmday:alarmDay];
    [alarm setAlarmweek:alarmWeek];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"HH"];
    NSString *hour = [df stringFromDate:alarmDate];
    [alarm setAlarmhour:[NSNumber numberWithInt:[hour intValue]]];
    
    [df setDateFormat:@"mm"];
    NSString *min = [df stringFromDate:alarmDate];
    [alarm setAlarmminute:[NSNumber numberWithInt:[min intValue]]];
    
    return alarm;
}

+(void)saveAlarmDB
{
    NSError* error;
    [[alarmDB context] save:&error];
    
    if (error) {
        UIAlertView *hibaAblak = [[UIAlertView alloc] initWithTitle:@"Hiba!" message:@"Hiba történt mentés során" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [hibaAblak show];
    }
}


@end
