//
//  APPRequestJSON.h
//  Appliances
//
//  Created by yekaiyu on 14-10-28.
//  Copyright (c) 2014年 yekaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

NSString * UsernameID;
NSString * PasswordID;

typedef void (^RequestBlock)(BOOL success);

@interface APPRequestJSON : NSObject

@property(nonatomic,assign) BOOL isLoading;

@property(nonatomic,strong) NSMutableArray* items;

@property(nonatomic,copy) NSString* currentLanguage;

-(void) Login:(NSString *) Username andPassword:(NSString *)Password;

-(void)requestJSON:(NSString *)requestUrl completion:(RequestBlock)block;;

-(void)hideHUD:(UIViewController *)controller;

-(void)showHUD:(UIViewController *)controller WithMBProgressHUDMode:(MBProgressHUDMode)hudMode;

@end
