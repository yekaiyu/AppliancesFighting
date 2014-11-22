//
//  LoginViewController.m
//  Appliances
//
//  Created by qiufawen on 1/11/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import "LoginViewController.h"
#import "APPRequestJSON.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    promptAlert =NULL;
}

- (IBAction)Login:(id)sender {
    if ([[_UserName text] length] == 0) {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                    message:@"Please input Username!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
        [promptAlert show];
    }
    else if ([[_Password text] length] == 0){
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Please input Password!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
    }

    [_Spin startAnimating];
    APPRequestJSON* requestJSON;
    requestJSON = [[APPRequestJSON alloc]init];
    [requestJSON Login:[_UserName text] andPassword:[_Password text]];
    [_Spin stopAnimating];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
