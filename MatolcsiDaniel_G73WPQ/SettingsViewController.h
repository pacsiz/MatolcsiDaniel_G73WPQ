//
//  SettingsViewController.h
//  MatolcsiDaniel_G73WPQ
//
//  Created by user on 2014.05.07..
//  Copyright (c) 2014 OE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationManager.h"
@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *OnOffSwitch;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UITextField *snoozeTime;

@end
