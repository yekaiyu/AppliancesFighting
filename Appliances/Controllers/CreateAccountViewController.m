//
//  CreateAccountViewController.m
//  Appliances
//
//  Created by qiufawen on 3/11/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "NetService.h"
#import "Constant.h"
@interface CreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *RePassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spin;

@property (nonatomic, weak) id cCreateAccountFailObject;
@property (nonatomic, weak) id cCreateAccountSuccessObject;
@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CreatAccount:(id)sender {
    if ([[_UserName text] length] == 0) {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Please input Username!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
        [promptAlert show];
        return;
    }
    else if ([[_Password text] length] == 0){
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Please input Password!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
        [promptAlert show];
        return;
    }
    else if (![[_Password text] isEqualToString:[_RePassword text]])
    {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Password not equal!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
        [promptAlert show];
        return;
    }
    else if ([[_RePassword text] length] == 0){
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Please input Re-enter Password!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
        [promptAlert show];
        return;
    }
    [_Spin startAnimating];
    NSString *keyArray[5];
    NSString *valueArray[5];
    
    keyArray[0] = @"id";
    valueArray[0] = [_UserName text];
    keyArray[1] = @"password";
    valueArray[1] = [_Password text];
    keyArray[2] = @"email";
    valueArray[2] = @"null@null.com";
    keyArray[3] = @"firstName";
    valueArray[3] = @"null";
    keyArray[4] = @"lastName";
    valueArray[4] = @"null";
    NSDictionary * Account = [NSDictionary dictionaryWithObjects:(id *)valueArray
                                            forKeys:(id *)keyArray count:5];
    [[NetService sharedInstance] CreateAccount:Account];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    promptAlert =NULL;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_Spin) {
        [_Spin stopAnimating];
    }
    
    __weak CreateAccountViewController *welf = self;
    self.cCreateAccountFailObject = [[NSNotificationCenter defaultCenter] addObserverForName:CreateAccountFail object:Nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [welf CreateAccountFailed:note];
    }];
    self.cCreateAccountSuccessObject = [[NSNotificationCenter defaultCenter] addObserverForName:CreateAccountuccess object:Nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [welf CreateAccountSuccess:note];
    }];
}

- (void) CreateAccountFailed:(NSNotification *)note
{
    if (_Spin) {
        [_Spin stopAnimating];
    }
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"Create Account failed, Please re-try!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    [promptAlert show];
}
- (void) CreateAccountSuccess:(NSNotification *)note
{
    if (_Spin) {
        [_Spin stopAnimating];
    }
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"Create Account Success!" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
    [promptAlert show];
    promptAlert = NULL;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.cCreateAccountSuccessObject];
    [[NSNotificationCenter defaultCenter] removeObserver:self.cCreateAccountFailObject];
}

@end
