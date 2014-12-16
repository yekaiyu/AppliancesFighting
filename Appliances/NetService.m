//
//  NetService.m
//  Appliances
//
//  Created by qiufawen on 30/11/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetService.h"
#import "Constant.h"
#import "AFNetworking.h"

static NetService * cNetService = nil;

@interface NetService()

@property(nonatomic)   BOOL bLogin;
@property(nonatomic,copy)   NSMutableString * UsernameID;
@property(nonatomic,copy)   NSMutableString * PasswordID;
@property(nonatomic,copy)   NSMutableString * UserID;
@property(nonatomic,copy)   NSDictionary * Devices;
@end

@implementation NetService

-(NetService *)init
{
    self = [super init];
    if (self) {
        _bLogin = FALSE;
        _Devices = nil;
    }
    return self;
}

+(NetService *)sharedInstance
{
    if (cNetService == nil) {
        cNetService = [[NetService alloc] init];
    }
    return cNetService;
}

-(void) Login:(NSString *) Username andPassword:(NSString *)Password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:Username password:Password];
    [manager POST:cStrAuth parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dictionary = responseObject;
        
        _UsernameID = [[NSMutableString alloc] initWithString:[dictionary objectForKey:@"key"]];
        _PasswordID = [[NSMutableString alloc] initWithString:[dictionary objectForKey:@"secret"]];
        _UserID = [[NSMutableString alloc] initWithString:Username];
        _bLogin = TRUE;
        NSNotification * note = [[NSNotification alloc] initWithName:LoginSuccess object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _bLogin = FALSE;
        NSNotification * note = [[NSNotification alloc] initWithName:LoginFail object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }];
}

-(void) CreateAccount:(NSDictionary *) Account
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager POST:cStrCreateAccount parameters:Account success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNotification * note = [[NSNotification alloc] initWithName:CreateAccountuccess object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSNotification * note = [[NSNotification alloc] initWithName:CreateAccountFail object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }];
}

-(NSDictionary*) GetDevice
{
    _Devices = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_UsernameID password:_PasswordID];
    NSString * cStrGetDev = [[NSString alloc] initWithFormat:cStrGetDevices, _UserID];
    AFHTTPRequestOperation * Operation = [manager POST:cStrGetDev parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _Devices = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [Operation waitUntilFinished];

    return _Devices;
}

-(BOOL) isLogin
{
    return _bLogin;
}
@end

