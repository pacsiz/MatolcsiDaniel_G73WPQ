//
//  SettingsViewController.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.05.07..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   	// Do any additional setup after loading the view.
    NSInteger snooze = [[NSUserDefaults standardUserDefaults] integerForKey:@"snooze"];
    if(snooze)
    {
        [self.stepper setValue:(double)snooze];
    }
    [self.snoozeTime setText:[NSString stringWithFormat:@"%d",(int)self.stepper.value]];
    
    NSString* OnOff = [[NSUserDefaults standardUserDefaults] objectForKey:@"state"];
    
    if ([OnOff isEqualToString:@"off"]) {
        [self.OnOffSwitch setOn:NO];
    }
    else
    {
        [self.OnOffSwitch setOn:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchChanged:(id)sender {
    if ([self.OnOffSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"state"];
        NSLog(@"on");
        [NotificationManager setNotificationForAllAlarm];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"state"];
         NSLog(@"off");
        [NotificationManager deleteAllNotification];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)snoozeChanged:(id)sender {
    [self.snoozeTime setText:[NSString stringWithFormat:@"%d",(int)self.stepper.value]];
    [[NSUserDefaults standardUserDefaults] setInteger:(int)self.stepper.value forKey:@"snooze"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
