//
//  AlarmsViewController.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.04.09..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "AlarmsViewController.h"
#import "AlarmDetailViewController.h"
#import "AppDelegate.h"


@interface AlarmsViewController ()


@end

@implementation AlarmsViewController
{
    NSArray *_alarms;
     NSFetchedResultsController* _fetchedResultsController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"Ntoi tömb mérete: %d", [notifications count]);
    for (UILocalNotification *notif in notifications) {
        NSDictionary *current = notif.userInfo;
        NSLog(@"Létező notif: %@:",current);
        NSLog(@"notif firedat: %@", notif.fireDate);
        NSLog(@"Rendszerdátum: %@",[NSDate date]);
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Alarms"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"alarmname" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[alarmDB context]
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    

    if (![_fetchedResultsController performFetch:&error])
    {
        NSLog(@"Hiba a lekérdezéskor %@, %@", error, [error userInfo]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AlarmDetailSegue"])
    {
        AlarmDetailViewController* alarmVC = segue.destinationViewController;
        alarmVC.modifiThis = [_fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. Csak egy szekció van
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [_fetchedResultsController sections][section];
    return  [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlarmCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
     
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    Alarms *alarm = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = alarm.alarmname;
    
    NSString *weekString;
    NSString *dayString;
    
    switch ([alarm.alarmweek intValue]){
        case 0:
            weekString = @"Minden hét";
            break;
        case 1:
            weekString = @"Páratlan hét";
            break;
        case 2:
            weekString = @"Páros hét";
            break;
        default:
            break;
    }
    
    switch ([alarm.alarmday intValue]){
        case 1:
            dayString = @"vasárnap";
            break;
        case 2:
            dayString = @"hétfő";
            break;
        case 3:
            dayString = @"kedd";
            break;
        case 4:
            dayString = @"szerda";
            break;
        case 5:
            dayString = @"csütörtök";
            break;
        case 6:
            dayString = @"péntek";
            break;
        case 7:
            dayString = @"szombat";
            break;
        default:
            break;
    }

    NSString *hourString = [[NSString alloc]init];
    NSString *minuteString = [[NSString alloc]init];
    
    
    if ([alarm.alarmhour stringValue].length == 1 ) {
        hourString = [NSString stringWithFormat:@"0%@",alarm.alarmhour];
    }
    else{
        hourString = alarm.alarmhour.stringValue;
    }
    
    if ([alarm.alarmminute stringValue].length == 1 ) {
       minuteString = [NSString stringWithFormat:@"0%@",alarm.alarmminute];
    }
    else{
       minuteString = alarm.alarmminute.stringValue;
    }
    
    NSString *labelText = [NSString stringWithFormat:@"%@:%@",hourString,minuteString];
    
    labelText = [labelText stringByAppendingString:@", "];
    labelText = [labelText stringByAppendingString:dayString];
    labelText = [labelText stringByAppendingString:@", "];
    labelText = [labelText stringByAppendingString:weekString];
    cell.detailTextLabel.text = labelText;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     
     NSLog(@"Törlés ok");
     Alarms *delete = [_fetchedResultsController objectAtIndexPath:indexPath];
     [NotificationManager deleteNotificationByAlarmName:delete.alarmname];
     
     [[alarmDB context] deleteObject:delete];
     [[alarmDB context] save:nil];

 }
 }

- (void)controllerWillChangeContent:
(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
         
            [NotificationManager setNewLocalNotification:[_fetchedResultsController objectAtIndexPath:newIndexPath]];

            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            //NSLog(@"change detected");
            
            [self.tableView reloadData];
            
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
