//
//  ViewController.m
//  T2
//
//  Created by Brammanand on 12/26/14.
//  Copyright (c) 2014 Brammanand. All rights reserved.
//

#import "ViewController.h"
#import "GetAlarmsViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *alarmTextField;

- (IBAction)setAlarmPressed:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Set Alarm";
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:10];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmAction:) name:@"alarmAction" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alarmAction:(NSNotification *)notification
{
    [self scheduleAlarmWithText:[notification.userInfo objectForKey:@"title"] andDate:(NSDate *)[NSDate dateWithTimeIntervalSinceNow:10.0]];
}

- (IBAction)setAlarmPressed:(UIButton *)sender {
    if (self.alarmTextField.text.length > 0) {
        [self scheduleAlarmWithText:_alarmTextField.text andDate:[_datePicker date]];
        [self showAlet:nil andMessage:@"Your alarm has been set."];
    }
    else {
        [self showAlet:@"Title missing !" andMessage:@"Please enter alarm title"];
    }
}

- (void)showAlet:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)scheduleAlarmWithText:(NSString *)text andDate:(NSDate *)date
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = date;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = text;
    notif.alertAction = @"Snooze";
    notif.soundName = @"alarm.wav";
    notif.userInfo = [NSDictionary dictionaryWithObject:_alarmTextField.text forKey:kAlarmNotificationKey];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    NSLog(@"notification = %@",notif);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
