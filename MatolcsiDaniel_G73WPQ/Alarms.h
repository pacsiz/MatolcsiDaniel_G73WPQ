//
//  Alarms.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.04.12..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alarms : NSManagedObject

@property (nonatomic, retain) NSNumber * alarmday;
@property (nonatomic, retain) NSNumber * alarmhour;
@property (nonatomic, retain) NSNumber * alarmminute;
@property (nonatomic, retain) NSString * alarmname;
@property (nonatomic, retain) NSNumber * alarmweek;

@end
