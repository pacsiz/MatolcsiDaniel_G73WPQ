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
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.alarmName setDelegate:self];
    
    //ha egy adott alarmot akarunk módosítani, akkor annak az adatait beállítjuk a view-on
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger retVal;
    if (component == 0) { // A hét napjai
        retVal = 7;
    }
    else
        retVal = 3; //páros/páratlan/minden hét
    return retVal;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *retVal;
    
    if (component == 0) {
        NSLocale *huLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"hu"];
        NSDateFormatter *df;
        df = [[NSDateFormatter alloc] init];
        [df setLocale:huLocale];
        
        retVal = [[df weekdaySymbols] objectAtIndex:row];
    }
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

- (IBAction)save:(id)sender {
    
    NSArray *alarm = [AlarmManager doesAlarmExistByName:self.alarmName.text];
    NSInteger week = [self.alarmDayandWeek selectedRowInComponent:1];
    NSInteger day = [self.alarmDayandWeek selectedRowInComponent:0]+1;
    Alarms *currentAlarm;
    
    
    if (self.modifiThis) {
        //a módosítandó alarm neve lehet új, még nem létező név vagy a saját régi neve
        if ((![self.modifiThis.alarmname isEqualToString:self.alarmName.text] && alarm.count > 0) || [self.alarmName.text isEqualToString:@""]) {
            [self nameExistAlert];
        }
        else {//módosítás esetén a korábbi notification törlődik, mentjük a változtatásokat és létrehozzuk az új noti.-t
            currentAlarm = self.modifiThis;
            [NotificationManager deleteNotificationByAlarmName:self.modifiThis.alarmname];
            [AlarmManager setAlarmDetailsOf:currentAlarm alarmName:self.alarmName.text alarmDay:[NSNumber numberWithInt:day] alarmWeek:[NSNumber numberWithInt:week] alarmDate:self.alarmTime.date];
            
            [NotificationManager setNewLocalNotification:currentAlarm];
            [AlarmManager saveAlarmDB];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    else {
        
        //új alarm neve egyedi kell, hogy legyen és nem lehet üres
        if (alarm.count > 0 || [self.alarmName.text isEqualToString:@""])
        {
            [self nameExistAlert];
        }
        else
        {
            currentAlarm = [AlarmManager newAlarm];
            [AlarmManager setAlarmDetailsOf:currentAlarm alarmName:self.alarmName.text alarmDay:[NSNumber numberWithInt:day] alarmWeek:[NSNumber numberWithInt:week] alarmDate:self.alarmTime.date];
            
            [AlarmManager saveAlarmDB];
            //visszalépés az előző view-ra
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.alarmName resignFirstResponder];
}

@end
