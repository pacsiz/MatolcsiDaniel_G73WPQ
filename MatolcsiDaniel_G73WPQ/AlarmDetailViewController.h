//
//  AlarmDetailViewController.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.04.11..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Alarms.h"
#import "alarmDB.h"
#import "AlarmManager.h"
#import "NotificationManager.h"
@interface AlarmDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *alarmName;
@property (weak, nonatomic) IBOutlet UIPickerView *alarmDayandWeek;
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmTime;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@property (strong, nonatomic) Alarms *modifiThis;

- (IBAction)textEditingDidEnd:(id)sender;

- (IBAction)save:(id)sender;

@end
