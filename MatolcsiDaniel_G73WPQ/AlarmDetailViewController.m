//
//  AlarmDetailViewController.m
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.04.11..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import "AlarmDetailViewController.h"

@interface AlarmDetailViewController ()

@end

@implementation AlarmDetailViewController


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
    [self.alarmName setDelegate:self];
    
    if (self.modifiThis) {
        self.alarmName.text = self.modifiThis.alarmname;
        [self.alarmDayandWeek selectRow:self.modifiThis.alarmday.intValue-1 inComponent:0 animated:YES ];
        [self.alarmDayandWeek selectRow:self.modifiThis.alarmweek.intValue inComponent:1 animated:YES ];
        
        NSString *time = [NSString stringWithFormat:@"%@:%@",self.modifiThis.alarmhour.stringValue,self.modifiThis.alarmminute.stringValue];

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setLocale:self.alarmTime.locale];
        [formatter setDateFormat:@"HH:mm"];

        NSDate *date = [formatter dateFromString:time];
      
        [self.alarmTime setDate:date];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)textEditingDidEnd:(id)sender {
    [self.alarmName resignFirstResponder];
}

-(void)nameExistAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hiba"
                                                    message:@"A megadott név létezik vagy üres!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

- (IBAction)save:(id)sender {
    
    NSArray *alarm = [AlarmManager doesAlarmExistByName:self.alarmName.text];
    NSInteger week = [self.alarmDayandWeek selectedRowInComponent:1];
    NSInteger day = [self.alarmDayandWeek selectedRowInComponent:0]+1;
    Alarms *currentAlarm;
    
    if (self.modifiThis) {
        if ((![self.modifiThis.alarmname isEqualToString:self.alarmName.text] && alarm.count > 0) || [self.alarmName.text isEqualToString:@""]) {
            [self nameExistAlert];
        }
        else {
            currentAlarm = self.modifiThis;
            [NotificationManager deleteNotificationByAlarmName:self.modifiThis.alarmname];
            [AlarmManager setAlarmDetailsOf:currentAlarm alarmName:self.alarmName.text alarmDay:[NSNumber numberWithInt:day] alarmWeek:[NSNumber numberWithInt:week] alarmDate:self.alarmTime.date];
            [NotificationManager deleteNotificationByAlarmName:self.modifiThis.alarmname];
            
            [NotificationManager setNewLocalNotification:currentAlarm];
            [AlarmManager saveAlarmDB];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    else {
    
        if (alarm.count > 0 || [self.alarmName.text isEqualToString:@""])
        {
            [self nameExistAlert];
        }
        else
        {
            currentAlarm = [AlarmManager newAlarm];
            [AlarmManager setAlarmDetailsOf:currentAlarm alarmName:self.alarmName.text alarmDay:[NSNumber numberWithInt:day] alarmWeek:[NSNumber numberWithInt:week] alarmDate:self.alarmTime.date];
            
            [AlarmManager saveAlarmDB];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger retVal;
    if (component == 0) { // A hét napjai
        retVal = 7;
    } // A hét napjai
else
    retVal = 3;
    return retVal;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *retVal;
    
    if (component == 0) { // A hét napjai
        NSLocale *huLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"hu"];
        NSDateFormatter *df;
        df = [[NSDateFormatter alloc] init];
        [df setLocale:huLocale];
        
        retVal = [[df weekdaySymbols] objectAtIndex:row];
          } // A hét napja
else
{
    switch (row) {
        case 0:
            retVal = @"Minden hét";
            break;
        case 1:
            retVal = @"Páratlan hét";
            break;
        case 2:
            retVal = @"Páros hét";
        default:
            break;
    }
}
    return retVal;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.alarmName resignFirstResponder];
}

@end
