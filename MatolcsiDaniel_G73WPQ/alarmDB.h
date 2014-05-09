//
//  alarmDB.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.04.11..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface alarmDB : NSObject

+(NSManagedObjectContext*) context;
+(NSManagedObjectModel*) model;
+(NSPersistentStoreCoordinator*) store;
+(void) setContext:(NSManagedObjectContext*) con;
+(void) setModel:(NSManagedObjectModel*) mod;
+(void) setStore:(NSPersistentStoreCoordinator*) str;

@end
