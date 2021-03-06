//
//  LoginViewController.m
//  Appliances
//
//  Created by qiufawen on 1/11/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import "LoginViewController.h"
#import "APPRequestJSON.h"
#import "Constant.h"
#import "NetService.h"
#import "AppDelegate.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spin;

@property (nonatomic, weak) id cLoginFailObject;
@property (nonatomic, weak) id cLoginSuccessObject;
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

    [_Spin startAnimating];
    [[NetService sharedInstance] Login:[_UserName text] andPassword:[_Password text]];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_Spin) {
        [_Spin stopAnimating];
    }
    [self.navigationController setNavigationBarHidden:YES];
    
    
    __weak LoginViewController *welf = self;
    self.cLoginFailObject = [[NSNotificationCenter defaultCenter] addObserverForName:LoginFail object:Nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [welf LoginFailed:note];
    }];
    self.cLoginSuccessObject = [[NSNotificationCenter defaultCenter] addObserverForName:LoginSuccess object:Nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [welf LoginSuccess:note];
    }];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}
- (void) LoginFailed:(NSNotification *)note
{
    if (_Spin) {
        [_Spin stopAnimating];
    }
}
- (void) LoginSuccess:(NSNotification *)note
{
    if (_Spin) {
        [_Spin stopAnimating];
    }
    
    //使用Storyboard初始化根界面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyBoard instantiateInitialViewController];
    
//    [self.navigationController pushViewController:vc animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![appDelegate InitUser:YES]) {
        [self ShowPrompt:@"Init user information failed!"];
        return;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self.cLoginFailObject];
    [[NSNotificationCenter defaultCenter] removeObserver:self.cLoginSuccessObject];
}
/*
#pragma mark - Navigation


- // In a storyboard-based application, you will often want to do a little preparation before navigation(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)ShowPrompt:(NSString *)strPrompt
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:strPrompt delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1
                                 target:self
                               selector:@selector(timerFireMethod:)
                               userInfo:promptAlert
                                repeats:NO];
    [promptAlert show];
}

@end
