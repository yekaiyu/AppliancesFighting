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

@implementation NetService


+(void) Login:(NSString *) Username andPassword:(NSString *)Password
{
//    [UsernameID setString:Username];
//    [[AFJSONRequestSerializer serializer] setAuthorizationHeaderFieldWithUsername:Username password:Password];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:Username password:Password];
    [manager POST:cStrAuth parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dictionary = responseObject;
        UsernameID = [dictionary objectForKey:@"key"];
        PasswordID = [dictionary objectForKey:@"secret"];
        NSNotification * note = [[NSNotification alloc] initWithName:LoginSuccess object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSNotification * note = [[NSNotification alloc] initWithName:LoginFail object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }];
}

@end

