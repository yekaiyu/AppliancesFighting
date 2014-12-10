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
static NSMutableString * UsernameID = nil;
static NSMutableString * PasswordID = nil;
static NSMutableString * UserID = nil;
@implementation NetService


+(void) Login:(NSString *) Username andPassword:(NSString *)Password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:Username password:Password];
    [manager POST:cStrAuth parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dictionary = responseObject;
        [UsernameID initWithString:[dictionary objectForKey:@"key"]];
        [PasswordID initWithString:[dictionary objectForKey:@"secret"]];
        [UserID initWithString:Username];
        NSNotification * note = [[NSNotification alloc] initWithName:LoginSuccess object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSNotification * note = [[NSNotification alloc] initWithName:LoginFail object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }];
}

+(void) CreateAccount:(NSDictionary *) Account
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

+(void) GetDevice
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:UsernameID password:PasswordID];
    NSString * cStrGetDev = [[NSString alloc] initWithFormat:cStrGetDevices, UserID];
    [manager POST:cStrGetDev parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNotification * note = [[NSNotification alloc] initWithName:LoginSuccess object:nil userInfo:responseObject];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSNotification * note = [[NSNotification alloc] initWithName:LoginFail object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }];
}
@end

