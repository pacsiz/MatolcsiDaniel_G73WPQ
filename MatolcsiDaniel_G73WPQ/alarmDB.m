//
//  alarmDB.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.04.11..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "alarmDB.h"

static NSManagedObjectContext* context;
static NSManagedObjectModel* model;
static NSPersistentStoreCoordinator* store;

@implementation alarmDB

+(NSManagedObjectContext *)context
{
    return context;
}

+(NSManagedObjectModel *)model {
    return model;
}

+(NSPersistentStoreCoordinator *)store {
    return store;
}

+(void)setContext:(NSManagedObjectContext *)con {
    context = con;
}

+(void)setModel:(NSManagedObjectModel *)mod {
    model = mod;
}

+(void)setStore:(NSPersistentStoreCoordinator *)str {
    store = str;
}


@end
